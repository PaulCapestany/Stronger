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


@synthesize delegate, dataSource, tableView, m_WorkoutPassedIn, m_WorkoutDocId;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    LogFunc;

    [super viewDidLoad];

    [CBLUITableSource class];     // Prevents class from being dead-stripped by linker
    dataSource.query = [M_Exercise exercisesQuery].asLiveQuery;
}

- (void)dealloc {
    LogFunc;

//    self.delegate = nil; 
//    dataSource = nil;
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

    LogErr(@"error: %@\nmessage: %@", error, message);
    [gAppDelegate showAlert: message error : error fatal : NO];
}

#pragma mark - TD table source delegate

// Customize the appearance of table view cells.
- (void)couchTableSource:(CBLUITableSource *)source
             willUseCell:(UITableViewCell *)cell
                  forRow:(CBLQueryRow *)row {
    LogFunc;

    // Configure the cell contents. Our view function (see above) copies the document properties
    // into its value, so we can read them from there without having to load the document.
    M_Exercise *exerciseForRow = [M_Exercise modelForDocument:row.document];

    LogVerbose(@"exerciseForRow", exerciseForRow);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = exerciseForRow.name;
}

#pragma mark - Table view delegate

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;

    CBLQueryRow *theRow = [dataSource rowAtIndexPath:indexPath];
    CBLDocument *doc = theRow.document;

    M_Exercise *selectedExercise = [M_Exercise modelForDocument:doc];
    LogAction(@"selectedExercise: %@", selectedExercise.name);
    LogVerbose(@"selectedExercise", selectedExercise);
    // TODO: add in ability to edit `selectedExercise`
    [self showV_Set:selectedExercise];
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
    
    
    NSString *cleanedUpText = [newExerciseTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (cleanedUpText != nil && ![cleanedUpText isEqual:@""]) {
        M_Exercise *newExercise =
        [M_Exercise createExercise:cleanedUpText
             belongs_to_workout_id:m_WorkoutPassedIn];
//    ???: this may have been causing crash with PonyDebugger...
        LogVerbose(@"newExercise", newExercise);
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
