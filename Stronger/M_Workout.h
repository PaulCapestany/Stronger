//
//  Workout.h
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

// M_Set belongs to M_Exercise which belongs to M_Workout

@interface M_Workout : CBLModel

+ (M_Workout *)createWorkoutWithName:(NSString *)name
                          inDatabase:(CBLDatabase *)database;

+ (M_Workout *)editWorkout:(NSString *)name
                forWorkout:(CBLDocument *)doc
                inDatabase:(CBLDatabase *)database;

// standard meta-data
@property (copy) NSArray* channels;
@property (retain) NSDate *a_creation_date;
@property (retain) NSString *a_creator;
@property (retain) NSDate *a_edit_date;
@property (retain) NSString *a_type;

// properties unique to Workouts
@property (copy) NSString *name;

@end
