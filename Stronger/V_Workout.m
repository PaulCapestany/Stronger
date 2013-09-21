//
//  V_Workout.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "V_Workout.h"
#import "M_Workout.h"
// connected stuff
#import "V_Exercise.h"
// sync stuff
#import "AppDelegate.h"
#import "ModelStore.h"


@implementation V_Workout
{
    M_Workout* _workout;
}

@synthesize delegate, dataSource, tableView;


- (M_Workout*) workout {
    return _workout;
}

- (void) setWorkout:(M_Workout *)workout {
    if (workout == _workout)
        return;
    _workout = workout;
    [self showWorkout];
}


- (void) showWorkout {
    dataSource.query = _workout.workoutQuery;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    LogFunc;

    [super viewDidLoad];

//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
//    self.navigationItem.leftBarButtonItem = editButton;

    [CBLUITableSource class];     // Prevents class from being dead-stripped by linker
}

- (void)dealloc {
    LogFunc;

    dataSource = nil;
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
//    LogDebug(_liveQuery);

//    LogDebug(@"AppDelegate.self", (AppDelegate *)[UIApplication sharedApplication].self, @"\nself", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    LogFunc;
    
    [super viewDidDisappear:animated];
}

- (void)showErrorAlert:(NSString *)message forError:(NSError *)error {
    LogFunc;

    LogErr(@"error: %@\nmessage: %@", error, message);
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
    M_Workout *workoutForRow = [M_Workout modelForDocument:row.document];

    LogVerbose(@"workoutForRow", workoutForRow);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = workoutForRow.name;
}

- (void)couchTableSource:(CBLUITableSource *)source
            deleteFailed:(NSError *)error {
    LogFunc;
    
    LogErr(@"couchTableSource:(CBLUITableSource *)source deleteFailed %@", error);
}

- (void)couchTableSource:(CBLUITableSource *)source
     willUpdateFromQuery:(CBLLiveQuery *)query {
    LogFunc;
    
    for (CBLQueryRow* myRow in dataSource.query.rows) {
        LogDebug(myRow);
    }
}


#pragma mark - Table view delegate

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;

    CBLQueryRow *theRow = [dataSource rowAtIndexPath:indexPath];
    CBLDocument *doc = theRow.document;

    M_Workout *selectedWorkout = [M_Workout modelForDocument:doc];
    LogAction(@"selectedWorkout: %@", selectedWorkout.name);
    LogVerbose(@"selectedWorkout", selectedWorkout);
    
    // TODO: add in ability to edit `selectedWorkout`
    [self showV_Exercise:selectedWorkout];
}

#pragma mark - Row reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    LogVerbose(@"sourceIndexPath", sourceIndexPath,
               @"proposedDestinationIndexPath", proposedDestinationIndexPath);
    
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    LogFunc;
}


#pragma mark - UITextField delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    LogFunc;

    LogAction(@"\"Done\" button pressed");
    [self finishedAddingNewWorkout];

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
    if ([newWorkoutTextField isFirstResponder] && [touch view] != newWorkoutTextField) {
        [newWorkoutTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

# pragma mark - Actions


- (IBAction)editButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"Edit\" button pressed");

    if (self.tableView.editing) {
        LogDebug(@"finished editing");
        [tableView setEditing:NO animated:YES];
    } else {
        LogDebug(@"started editing");
        [tableView setEditing:YES animated:YES];
    }
}

- (IBAction)addWorkoutButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"+ Workout\" button pressed");
    [self finishedAddingNewWorkout];
}

- (void)finishedAddingNewWorkout {
    LogFunc;
        
    [newWorkoutTextField resignFirstResponder];
    
    NSString *cleanedUpText = [newWorkoutTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (cleanedUpText != nil && ![cleanedUpText isEqual:@""]) {
        M_Workout *newWorkout =
        [_workout createWorkoutWithName:cleanedUpText];
        LogVerbose(@"newWorkout", newWorkout);
    }
    [newWorkoutTextField setText:nil];
}

# pragma mark - Segues to other views

- (void)showV_Exercise:(M_Workout *)selectedWorkout {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];

    V_Exercise *v_Exercise = [storyboard instantiateViewControllerWithIdentifier:@"V_Exercise"];
    v_Exercise.m_WorkoutPassedIn = selectedWorkout;
    v_Exercise.m_WorkoutDocId = selectedWorkout.document.documentID;

    [v_Exercise setTitle:selectedWorkout.name];
    
    if ([self navigationController]) {
        LogDebug(@"[self navigationController]");
        [[self navigationController] pushViewController:v_Exercise animated:YES];
    }
}

@end
