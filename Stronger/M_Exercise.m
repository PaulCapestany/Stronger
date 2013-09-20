//
//  M_ExercisesInWorkout.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Exercise.h"
#import <CouchbaseLite/CBLJSON.h>
#import "ModelStore.h"

@implementation M_Exercise

// meta
@dynamic    a_creation_date, a_creator, a_edit_date, type;

// properties
@dynamic    name, belongs_to_workout_id;

+ (M_Exercise *)createExercise:(NSString *)name
         belongs_to_workout_id:(M_Workout *)belongs_to_workout_id
                    inDatabase:(CBLDatabase *)database {
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSString *type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];

    M_Exercise *retval = [[M_Exercise alloc] initWithDocument:[database untitledDocument]];
    retval.autosaves = YES;

    // meta
    retval.a_creation_date = a_creation_date;
    retval.a_creator = [ModelStore sharedInstance].username;
    retval.type = type;

    // properties
    retval.name = name;
    retval.belongs_to_workout_id = belongs_to_workout_id;

    return retval;
}

+ (M_Exercise *)editExercise:(NSString *)name
       belongs_to_workout_id:(M_Workout *)belongs_to_workout_id
                 forExercise:(CBLDocument *)doc
                  inDatabase:(CBLDatabase *)database {
    M_Exercise *retval = [[M_Exercise alloc] initWithDocument:[database documentWithID:doc.documentID]];

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // META
    retval.a_creation_date = [doc.properties objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];
    retval.a_edit_date = [NSDate date];
    retval.type = [doc.properties objectForKey:@"type"];

    // PROPERTIES
    retval.name = [props objectForKey:@"name"];
    retval.belongs_to_workout_id = [props objectForKey:@"belongs_to_workout_id"];

    [latest putProperties:props error:nil];

    return retval;
}

@end
