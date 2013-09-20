//
//  V_Workouts.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CBLUITableSource.h>

@class CBLDatabase, M_Settings, CBLLiveQuery;

@protocol V_WorkoutsDelegate <NSObject>
@end

@interface V_Workout : UIViewController <CBLUITableDelegate, UITextFieldDelegate>
{
    BOOL _viewDidLoad;

    UITableView *tableView;

    IBOutlet UITextField *newWorkoutTextField;

    IBOutlet UIButton *saveButton;

    CBLLiveQuery *_liveQuery;
}

@property (nonatomic, weak) id <V_WorkoutsDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet CBLUITableSource *dataSource;

@end
