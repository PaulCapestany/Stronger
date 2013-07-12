//
//  RootViewController.m
//  TDbase Mobile
//
//  Created by Jan Lehnardt on 27/11/2010.
//  Copyright 2011 TDbase, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.
//

#import "V_Set.h"
#import "M_Set.h"
// sync stuff
#import "AppDelegate.h"

@implementation V_Set
{
    CBLDatabase *database;
    M_Set *selectedSet;
}

@synthesize delegate, dataSource, tableView, weightNumber, repsNumber, isEditing, m_ExercisePassedIn, m_ExerciseDocId;


#pragma mark - View lifecycle

- (void)viewDidLoadWithDatabase {
    LogFunc;

    if (!database) database = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).database;

    if (_viewDidLoad && database) {
        // Create a query sorted by descending date, i.e. newest items first:
        CBLLiveQuery *query = [[[database viewNamed:@"sets"] query] asLiveQuery];

        query.descending = NO;
        query.prefetch = YES;

        // want to only show the exercises that match the Workout we selected in V_Workouts
        query.startKey = [NSArray arrayWithObjects:m_ExerciseDocId, nil];
        query.endKey = [NSArray arrayWithObjects:m_ExerciseDocId,  [NSDictionary dictionary], nil];

        self.dataSource.query = query;
    }
}

- (void)viewDidLoad {
    LogFunc;

    [super viewDidLoad];

    [CBLUITableSource class];     // Prevents class from being dead-stripped by linker

    _viewDidLoad = YES;
    isEditing = NO;
    
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
    M_Set *setForRow = [M_Set modelForDocument:row.document];

    LogDebug(@"row.key : row.value = %@ : %@", row.key, row.value);

    cell.textLabel.text = [NSString stringWithFormat:@"%@ × %@", [setForRow.weight stringValue], [setForRow.reps stringValue]];
}

#pragma mark - Table view delegate

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;

    CBLQueryRow *theRow = [self.dataSource rowAtIndex:indexPath.row];
    CBLDocument *doc = theRow.document;

    selectedSet = [M_Set modelForDocument:doc];
    LogVerbose(@"selectedSet: \n%@", selectedSet);
    
    // TODO: add in ability to edit `selectedSet`
    [weightTextField setText:[selectedSet.weight stringValue]];
    [repsTextField setText:[selectedSet.reps stringValue]];

    isEditing = YES;
    saveButton.titleLabel.text = @"Save Edit";
}

#pragma mark - Editing:


#pragma mark - UITextField delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    LogFunc;

    LogAction(@"\"Done\" button pressed");
    [self finishedAddingNewSet];
    
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
    if ([weightTextField isFirstResponder] && [touch view] != weightTextField) {
        [weightTextField resignFirstResponder];
    }
    if ([repsTextField isFirstResponder] && [touch view] != repsTextField) {
        [repsTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (NSNumber *)convertTextFieldStringToNumber:(NSString *)theString {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *convertedNumber = [format numberFromString:theString];

    return convertedNumber;
}

# pragma mark - Actions

- (IBAction)increaseWeightButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"↑ weight\" button pressed");

    weightNumber = [NSNumber numberWithFloat:[[self convertTextFieldStringToNumber:weightTextField.text] floatValue] + 1.0];
    [weightTextField setText:[weightNumber stringValue]];
}

- (IBAction)decreaseWeightButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"↓ weight\" button pressed");

    weightNumber = [NSNumber numberWithFloat:[[self convertTextFieldStringToNumber:weightTextField.text] floatValue] - 1.0];
    [weightTextField setText:[weightNumber stringValue]];
}

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////


- (IBAction)increaseRepsButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"↑ reps\" button pressed");

    repsNumber = [NSNumber numberWithFloat:[[self convertTextFieldStringToNumber:repsTextField.text] floatValue] + 1.0];
    [repsTextField setText:[repsNumber stringValue]];
}

- (IBAction)decreaseRepsButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"↓ reps\" button pressed");

    repsNumber = [NSNumber numberWithFloat:[[self convertTextFieldStringToNumber:repsTextField.text] floatValue] - 1.0];
    [repsTextField setText:[repsNumber stringValue]];
}

//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)addSetButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"Add Set\" button pressed");
    [self finishedAddingNewSet];
}

- (void)finishedAddingNewSet {
    LogFunc;
    
    if ([weightTextField isFirstResponder]) {
        [weightTextField resignFirstResponder];
    }
    if ([repsTextField isFirstResponder]) {
        [repsTextField resignFirstResponder];
    }
    
    weightNumber = [self convertTextFieldStringToNumber:weightTextField.text];
    repsNumber = [self convertTextFieldStringToNumber:repsTextField.text];
    
    [weightTextField setText:nil];
    [repsTextField setText:nil];
    
    if (isEditing) {
//        [M_Set editSetWithWeight:weightNumber reps:repsNumber forSet:selectedSet.document inDatabase:database];
        selectedSet.weight = weightNumber;
        selectedSet.reps = repsNumber;
        NSError *error;
        [selectedSet save:&error];
        
        isEditing = NO;
        saveButton.titleLabel.text = @"Add Set";
    }
    else {
    M_Set *newSet =
    [M_Set createSetWithWeight:weightNumber
                          reps:repsNumber
        belongs_to_exercise_id:m_ExercisePassedIn
                    inDatabase:database];
    
    LogVerbose(@"newSet: \n%@", newSet);
    }
}

@end
