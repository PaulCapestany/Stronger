//
//  V_Workouts.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CBLUITableSource.h>

@class CBLLiveQuery;

@protocol V_WorkoutsDelegate <NSObject>
@end

@interface V_Workout : UIViewController <CBLUITableDelegate, UITextFieldDelegate>
{
    UITableView *tableView;

    IBOutlet UITextField *newWorkoutTextField;

    IBOutlet UIButton *saveButton;
}

@property (nonatomic, weak) id <V_WorkoutsDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet CBLUITableSource *dataSource;

@end
