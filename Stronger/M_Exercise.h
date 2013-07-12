//
//  M_ExercisesInWorkout.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@class M_Workout;

// M_Set belongs to M_Exercise which belongs to M_Workout

@interface M_Exercise : CBLModel

+ (M_Exercise *)createExercise:(NSString *)name
         belongs_to_workout_id:(M_Workout *)belongs_to_workout_id
                    inDatabase:(CBLDatabase *)database;

+ (M_Exercise *)editExercise:(NSString *)name
       belongs_to_workout_id:(M_Workout *)belongs_to_workout_id
                 forExercise:(CBLDocument *)doc
                  inDatabase:(CBLDatabase *)database;

// standard meta-data
//@property (copy) NSArray* channels;
@property (retain) NSDate *a_creation_date;
@property (retain) NSString *a_creator;
@property (retain) NSDate *a_edit_date;
@property (retain) NSString *a_type;


// properties unique to Sets
@property (copy) NSString *name;
@property (assign) M_Workout *belongs_to_workout_id;
// TODO: should probably relate to pre-fab exercises

@end
