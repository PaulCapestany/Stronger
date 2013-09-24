//
//  Workout.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "MetaModel.h"

@class ModelStore;

// M_Set belongs to M_Exercise which belongs to M_Workout

@interface M_Workout : MetaModel

+ (CBLQuery*) workoutsQuery;

+ (M_Workout *)createWorkoutWithName:(NSString *)name;

@property (readwrite) NSString* name;
@property (readonly) NSString* created_by;


@end
