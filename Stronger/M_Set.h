//
//  M_Set.h
//  Workouts
//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@class M_Exercise;

// M_Set belongs to M_Exercise which belongs to M_Workout

@interface M_Set : CBLModel

+ (M_Set *)createSetWithWeight:(NSNumber *)weight
                          reps:(NSNumber *)reps
        belongs_to_exercise_id:(M_Exercise *)belongs_to_exercise_id
                    inDatabase:(CBLDatabase *)database;

+ (M_Set *)editSetWithWeight:(NSNumber *)weight
                        reps:(NSNumber *)reps
                      forSet:(CBLDocument *)doc
                  inDatabase:(CBLDatabase *)database;

// standard meta-data
@property (retain) NSDate *a_creation_date;
@property (retain) NSString *a_creator;
@property (retain) NSDate *a_edit_date;
@property (retain) NSString *type;

// properties unique to Sets
@property (copy) NSNumber *weight;
@property (copy) NSNumber *reps;
@property (assign) M_Exercise *belongs_to_exercise_id;

@end
