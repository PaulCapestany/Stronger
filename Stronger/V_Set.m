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
    M_Set *setForRow;
}

@synthesize delegate, dataSource, tableView, isEditing,  m_ExercisePassedIn, m_ExerciseDocId, weightViewArray, repsViewArray;


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
    [saveButton setTitle:@"Add Set" forState:UIControlStateNormal];
    self.weightViewArray = @[@0, @5, @10, @15, @20, @25, @30, @35, @40, @45, @50, @55, @60, @65, @70, @80, @85, @90];
    self.repsViewArray = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, @25, @26, @27, @28, @29, @30, @31, @32, @33, @34, @35, @36, @37, @38, @39, @40, @41, @42, @43, @44, @45, @46, @47, @48, @49, @50];
    
    [self viewDidLoadWithDatabase];
}

- (void)dealloc {
    LogFunc;

    self.weightViewArray = nil;
    self.repsViewArray = nil;
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

#pragma mark - CBLUITableSource delegate

// Customize the appearance of table view cells.
- (void)couchTableSource:(CBLUITableSource *)source
             willUseCell:(UITableViewCell *)cell
                  forRow:(CBLQueryRow *)row {
    LogFunc;

    // Configure the cell contents. Our view function (see above) copies the document properties
    // into its value, so we can read them from there without having to load the document.
    setForRow = [M_Set modelForDocument:row.document];

    LogDebug(@"row.key : row.value = %@ : %@", row.key, row.value);

    cell.textLabel.text = [NSString stringWithFormat:@"%@                             %@", [setForRow.weight stringValue], [setForRow.reps stringValue]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
}

// Allows delegate to return its own custom cell, just like -tableView:cellForRowAtIndexPath:
//- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source
//                cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//}

#pragma mark - Table view delegate

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogFunc;

    CBLQueryRow *theRow = [self.dataSource rowAtIndex:indexPath.row];
    CBLDocument *doc = theRow.document;

    selectedSet = [M_Set modelForDocument:doc];
    LogVerbose(@"selectedSet: \n%@", selectedSet);
    isEditing = YES;
    
    [weightAndRepsPickerView selectRow:[weightViewArray indexOfObject:selectedSet.weight] inComponent:0 animated:YES];
    [weightAndRepsPickerView selectRow:[selectedSet.reps integerValue] inComponent:1 animated:YES];

    [saveButton setTitle:@"Done Editing" forState:UIControlStateNormal];
}

#pragma mark - Editing:


#pragma mark - UIPickerView delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    LogFunc;
    NSInteger returnInt = 0;
    
    if (component == 0)
    {
        returnInt = [weightViewArray count];
    }
    if (component == 1)
    {
        returnInt = [repsViewArray count];
    }
    
	return returnInt;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    LogFunc;
    return 2;
}

#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *returnStr = @"";
	
    if (component == 0)
    {
        returnStr = [[weightViewArray objectAtIndex:row] stringValue];
    }
    if (component == 1)
    {
        returnStr = [[repsViewArray objectAtIndex:row] stringValue];
    }
	
	return returnStr;
}


# pragma mark - Actions

- (IBAction)addSetButtonPressed:(id)sender {
    LogFunc;

    LogAction(@"\"Add Set\" button pressed");
    [self finishedWithSet];
}

- (void)finishedWithSet {
    LogFunc;

    NSNumber *weightNumber = [weightViewArray objectAtIndex:[weightAndRepsPickerView selectedRowInComponent:0]];
    NSNumber *repsNumber = [repsViewArray objectAtIndex:[weightAndRepsPickerView selectedRowInComponent:1]];
    
    
    if (isEditing) {
        selectedSet.weight = weightNumber;
        selectedSet.reps = repsNumber;
        NSError *error;
        [selectedSet save:&error];
        
        isEditing = NO;
        [saveButton setTitle:@"Add Set" forState:UIControlStateNormal];
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        if(indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
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
