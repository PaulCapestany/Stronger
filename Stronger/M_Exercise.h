//
//  M_ExercisesInWorkout.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "MetaModel.h"

@class M_Workout;

// M_Set belongs to M_Exercise which belongs to M_Workout

@interface M_Exercise : MetaModel

+ (CBLQuery*) exercisesQuery;

+ (M_Exercise *)createExercise:(NSString *)name
         belongs_to_workout_id:(M_Workout *)belongs_to_workout_id;

@property (copy) NSString *name;
@property (assign) M_Workout *belongs_to_workout_id;
@property (readonly) NSString* owner_id;
// TODO: should probably relate to pre-fab exercises

@end
