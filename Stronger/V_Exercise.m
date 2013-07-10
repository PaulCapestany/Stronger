//
//  V_Exercise.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "V_Exercise.h"
#import "M_Exercise.h"
// connected stuff
#import "V_Set.h"
// sync stuff
#import "AppDelegate.h"

@implementation V_Exercise
{
    CBLDatabase *database;
}

@synthesize delegate, dataSource, tableView, m_WorkoutPassedIn, m_WorkoutDocId;


#pragma mark - View lifecycle

- (void)viewDidLoadWithDatabase {
    LogFunc;

    if (!database) database = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).database;

    if (_viewDidLoad && database) {
        // Create a query sorted by descending date, i.e. newest items first:
        CBLLiveQuery *query = [[[database viewNamed:@"exercises"] query] asLiveQuery];

        query.descending = NO;
        query.prefetch = YES;

        // want to only show the exercises that match the Workout we selected in V_Workouts
        query.startKey = [NSArray arrayWithObjects:m_WorkoutDocId, nil];
        query.endKey = [NSArray arrayWithObjects:m_WorkoutDocId,  [NSDictionary dictionary], nil];

        self.dataSource.query = query;
    }
}

- (void)viewDidLoad {
    LogFunc;

    [super viewDidLoad];

    [CBLUITableSource class];     // Prevents class from being dead-stripped by linker

    _viewDidLoad = YES;
    [self viewDidLoadWithDatabase];
}

- (void)dealloc {
    LogFunc;

    self.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    LogFunc;
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    LogFunc;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    LogFunc;
    
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    if(indexPath) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    LogFunc;
    
    [super viewDidDisappear:animated];
}

- (void)showErrorAlert:(NSString *)message forError:(NSError *)error {
    LogFunc;

    LogErr(@"%@: error=%@", message, error);
    [(AppDelegate *)[[UIApplication sharedApplication] delegate]
 showAlert: message error : error fatal : NO];
}

#pragma mark - TD table source delegate

// Customize the appearance of table view cells.
- (void)couchTableSource:(CBLUITableSource *)source
             willUseCell:(UITableViewCell *)cell
                  forRow:(CBLQueryRow *)row {
    LogFunc;

    // Configure the cell contents. Our view function (see above) copies the document properties
    // into its value, so we can read them from there without having to load the document.
    M_Exercise *ExerciseForRow = [M_Exercise modelForDocument:row.document];

    LogVerbose(@"%@\n"
              "★★★★★★★★★★★★★★★★★★ key ⤴ value ⤵ ★★★★★★★★★★★★★★★★★★ \n"
              "%@",
              row.key,
              row.value);

    cell.textLabel.text = ExerciseForRow.name;
}

#pragma mark - Table view delegate

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;

    CBLQueryRow *theRow = [self.dataSource rowAtIndex:indexPath.row];
    CBLDocument *doc = theRow.document;

    M_Exercise *selectedExercise = [M_Exercise modelForDocument:doc];
    LogAction(@"\"%@\" exercise selected", selectedExercise.name);
    LogVerbose(@"selectedExercise: \n%@", selectedExercise);
    // TODO: add in ability to edit `selectedExercise`
    [self showV_Set:selectedExercise];
}

#pragma mark - Editing:


#pragma mark - UITextField delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    LogFunc;

    LogAction(@"\"Done\" button pressed");
    [self finishedAddingNewExercise];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    LogFunc;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    LogFunc;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LogFunc;
    
    LogAction(@"Touched outside of responders");
    
    // taken from http://stackoverflow.com/questions/1456120/hiding-the-keyboard-when-losing-focus-on-a-uitextview
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([newExerciseTextField isFirstResponder] && [touch view] != newExerciseTextField) {
        [newExerciseTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

# pragma mark - Actions

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)addExerciseButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"+ Exercise\" button pressed");
    [self finishedAddingNewExercise];
}

- (void)finishedAddingNewExercise {
    LogFunc;

    [newExerciseTextField resignFirstResponder];
    
    if (newExerciseTextField.text != nil && ![newExerciseTextField.text isEqual:@""]) {
        M_Exercise *newExercise =
        [M_Exercise createExercise:newExerciseTextField.text
             belongs_to_workout_id:m_WorkoutPassedIn
                        inDatabase:database];
        
        LogVerbose(@"newExercise: \n%@", newExercise);
    }
    
    [newExerciseTextField setText:nil];
}

# pragma mark - Segues to other views

- (void)showV_Set:(M_Exercise *)selectedExercise {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];

    V_Set *v_Set = [storyboard instantiateViewControllerWithIdentifier:@"V_Set"];
    v_Set.m_ExercisePassedIn = selectedExercise;
    v_Set.m_ExerciseDocId = selectedExercise.document.documentID;

    [v_Set setTitle:selectedExercise.name];

    if ([self navigationController]) {
        LogDebug(@"[self navigationController]");
        [[self navigationController] pushViewController:v_Set animated:YES];
    }
}

@end
