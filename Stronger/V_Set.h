//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CouchbaseLite/CBLUITableSource.h>

@class CBLDatabase, M_Exercise, M_Set;

@protocol V_SetDelegate <NSObject>
@end

@interface V_Set : UIViewController <CBLUITableDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    BOOL _viewDidLoad;

    UITableView *myTableView;

    IBOutlet UIButton *saveButton;
    __weak IBOutlet UIPickerView *weightAndRepsPickerView;
}

@property (nonatomic, weak) id <V_SetDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet CBLUITableSource *myDataSource;

@property (nonatomic, retain) NSArray *weightViewArray;
@property (nonatomic, retain) NSArray *repsViewArray;

@property (nonatomic, retain) NSCountedSet *countedSet;

@property (nonatomic) BOOL isEditing;

@property (strong, nonatomic) M_Set* theSet;


// to pass to viewController
@property (nonatomic, retain) M_Exercise *m_ExercisePassedIn;
@property (nonatomic, retain) NSString *m_ExerciseDocId;


@end
