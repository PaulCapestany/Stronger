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


@implementation V_Workout
{
    CBLDatabase *database;
    M_Settings *settingsDoc;
    //    CBLQueryEnumerator *_
}

@synthesize delegate, dataSource, tableView, tempSettingsArray;


#pragma mark - View lifecycle

- (void)viewDidLoadWithDatabase {
    LogFunc;
    
    if (!database) database = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).database;
    if (!settingsDoc) settingsDoc = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).settingsDoc;

    if (_viewDidLoad && database) {
        // Create a query sorted by descending date, i.e. newest items first:
        _liveQuery = [[[database viewNamed:@"workouts"] query] asLiveQuery];

        dataSource.query = _liveQuery;
        [_liveQuery addObserver:self forKeyPath:@"rows" options:0 context:NULL];
    }
}

- (void)viewDidLoad {
    LogFunc;

    [super viewDidLoad];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)];
    self.navigationItem.leftBarButtonItem = editButton;

    [CBLUITableSource class];     // Prevents class from being dead-stripped by linker

    _viewDidLoad = YES;
    [self viewDidLoadWithDatabase];
}

- (void)dealloc {
    LogFunc;

    dataSource = nil;
    [_liveQuery removeObserver:self forKeyPath:@"rows"];
    _liveQuery = nil;
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
    LogDebug(_liveQuery);

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

#pragma mark - Editing:

// ???: different way to deal with errors now?
//if (![doc.currentRevision putProperties: docContent error: &error]) {
//    [self showErrorAlert: @"Failed to update item" forError: error];
//}

//- (void)couchTableSource:(CBLUITableSource*)source
//         operationFailed:(RESTOperation*)op
//{
////    NSString* message = op.isDELETE ? @"Couldn't delete item" : @"Operation failed";
//    [self showErrorAlert: message forOperation: op];
//}


#pragma mark - Row reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    LogVerbose(@"sourceIndexPath", sourceIndexPath,
               @"proposedDestinationIndexPath", proposedDestinationIndexPath);
    
    //
    ////    [tempSettingsArray exchangeObjectAtIndex: sourceIndexPath.row withObjectAtIndex: proposedDestinationIndexPath.row];
    //
    //    id sourceObject = [tempSettingsArray objectAtIndex: sourceIndexPath.row];
    //    [tempSettingsArray removeObjectAtIndex: sourceIndexPath.row];
    //    [tempSettingsArray insertObject: sourceObject atIndex: proposedDestinationIndexPath.row];
    //    LogVerbose(@"tempSettingsArray = \n%@", tempSettingsArray);

    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    LogFunc;

    // ???: need to make `moveRowAtIndexPath` actually get called!
    LogDebug(@"fromIndexPath", fromIndexPath,
             @"toIndexPath", toIndexPath);

    id sourceObject = [tempSettingsArray objectAtIndex:fromIndexPath.row];
    [tempSettingsArray removeObjectAtIndex:fromIndexPath.row];
    [tempSettingsArray insertObject:sourceObject atIndex:toIndexPath.row];
    LogVerbose(@"tempSettingsArray", tempSettingsArray);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    LogFunc;

// TODO: potentially unnecessary because I can just use willUpdateFromQuery
    if (object == _liveQuery) {
        NSMutableArray *tempRowsArray = [NSMutableArray array];
        for (CBLQueryRow *aCBLQueryRow in _liveQuery.rows) {
//            LogVerbose(@"aCBLQueryRow", aCBLQueryRow);
            [tempRowsArray addObject:aCBLQueryRow.key];
        }
        LogDebug(@"tempRowsArray", tempRowsArray);
        if (!tempSettingsArray) tempSettingsArray = [[NSMutableArray alloc] initWithArray:settingsDoc.workout_order];
        LogVerbose(@"tempSettingsArray", tempSettingsArray);
    }
}

- (void)updateSettingsArray {
    LogFunc;

    LogVerbose(@"tempSettingsArray", tempSettingsArray);
    settingsDoc.workout_order = [tempSettingsArray copy];
    settingsDoc.a_edit_date = [NSDate date];
    // ???: *save* method seems to have changed (no longer *RestOperation*-based)?
    [settingsDoc save:nil];
//    [saveItOp onCompletion:^{
//        LogDebug(@"saveItOp complete \nsettingsDoc = \n%@", settingsDoc.document.properties);
//    }];
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
//    PDLogD(@"DEBUG - iaosudoai sduio uoisa duoia sduoi asudio askjdh kjasd kjashd kjashd kjas dkjas dkjhas  djasdkjhas kjdhaskj dkjasd kjasd kjasd kjash dkaskjdhaskjdkjasd kjashd kjaskjdhaskjdkjasdkjasdkjhaskjdaskjdkjasdkjadskjaskjdhaskjdk  kjdashdkjs adkjashdkja sdkajshd kjas dhkjas dhkjsd kajsd kjasd kjasdkjadskjh");
//    PDLogW(@"WARN - iaosudoai sduio uoisa duoia sduoi asudio askjdh kjasd kjashd kjashd kjas dkjas dkjhas  djasdkjhas kjdhaskj dkjasd kjasd kjasd kjash dkaskjdhaskjdkjasd kjashd kjaskjdhaskjdkjasdkjasdkjhaskjdaskjdkjasdkjadskjaskjdhaskjdk  kjdashdkjs adkjashdkja sdkajshd kjas dhkjas dhkjsd kajsd kjasd kjasdkjadskjh");
//    PDLogI(@"INFO - iaosudoai sduio uoisa duoia sduoi asudio askjdh kjasd kjashd kjashd kjas dkjas dkjhas  djasdkjhas kjdhaskj dkjasd kjasd kjasd kjash dkaskjdhaskjdkjasd kjashd kjaskjdhaskjdkjasdkjasdkjhaskjdaskjdkjasdkjadskjaskjdhaskjdk  kjdashdkjs adkjashdkja sdkajshd kjas dhkjas dhkjsd kajsd kjasd kjasdkjadskjh");
//    PDLogE(@"ERROR - iaosudoai sduio uoisa duoia sduoi asudio askjdh kjasd kjashd kjashd kjas dkjas dkjhas  djasdkjhas kjdhaskj dkjasd kjasd kjasd kjash dkaskjdhaskjdkjasd kjashd kjaskjdhaskjdkjasdkjasdkjhaskjdaskjdkjasdkjadskjaskjdhaskjdk  kjdashdkjs adkjashdkja sdkajshd kjas dhkjas dhkjsd kajsd kjasd kjasdkjadskjh");
//    PDLog(@"Normal PDLog - iaosudoai sduio uoisa duoia sduoi asudio askjdh kjasd kjashd kjashd kjas dkjas dkjhas  djasdkjhas kjdhaskj dkjasd kjasd kjasd kjash dkaskjdhaskjdkjasd kjashd kjaskjdhaskjdkjasdkjasdkjhaskjdaskjdkjasdkjadskjaskjdhaskjdk  kjdashdkjs adkjashdkja sdkajshd kjas dhkjas dhkjsd kajsd kjasd kjasdkjadskjh");
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

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)editButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"Edit\" button pressed");

    if (self.tableView.editing) {
        LogDebug(@"finished editing");
        [self updateSettingsArray];
        [tableView setEditing:NO animated:YES];
    } else {
        LogDebug(@"started editing");
        [tableView setEditing:YES animated:YES];
    }
    //[self tableView:dataSource canMoveRowAtIndexPath:dataSource.tableView.indexPathForSelectedRow];
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
        [M_Workout createWorkoutWithName:cleanedUpText
                              inDatabase:database];
        [tempSettingsArray addObject:newWorkout.document.documentID];
        LogVerbose(@"newWorkout", newWorkout);
        [self updateSettingsArray];
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
