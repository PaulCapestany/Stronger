//
//  RootViewController.h
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

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CBLUITableSource.h>

@class CBLDatabase, M_Exercise, M_Set;

@protocol V_SetDelegate <NSObject>
@end

@interface V_Set : UIViewController <CBLUITableDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    BOOL _viewDidLoad;

    UITableView *tableView;

    IBOutlet UIButton *saveButton;
    __weak IBOutlet UIPickerView *weightAndRepsPickerView;
}

@property (nonatomic, weak) id <V_SetDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet CBLUITableSource *dataSource;

@property (nonatomic, retain) NSArray *weightViewArray;
@property (nonatomic, retain) NSArray *repsViewArray;

@property (nonatomic) BOOL isEditing;

@property (strong, nonatomic) M_Set* theSet;


// to pass to viewController
@property (nonatomic, retain) M_Exercise *m_ExercisePassedIn;
@property (nonatomic, retain) NSString *m_ExerciseDocId;


@end
