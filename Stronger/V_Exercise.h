//
//  V_Exercise.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CBLUITableSource.h>

@class CBLDatabase, M_Workout;

@protocol V_ExerciseDelegate <NSObject>
@end

@interface V_Exercise : UIViewController <CBLUITableDelegate, UITextFieldDelegate>
{
    BOOL _viewDidLoad;

    UITableView *tableView;

    IBOutlet UITextField *newExerciseTextField;

    IBOutlet UIButton *saveButton;
}

@property (nonatomic, weak) id <V_ExerciseDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet CBLUITableSource *dataSource;

// to pass to viewController
@property (nonatomic, retain) M_Workout *m_WorkoutPassedIn;
@property (nonatomic, retain) NSString *m_WorkoutDocId;

@end
