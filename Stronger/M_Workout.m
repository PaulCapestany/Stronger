//
//  Workout.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Workout.h"
#import <CouchbaseLite/CBLJSON.h>
#import "ModelStore.h"

@implementation M_Workout

// meta
@dynamic    a_creation_date, a_creator, a_edit_date, a_type;

// properties
@dynamic    name;

+ (M_Workout *)createWorkoutWithName:(NSString *)name
                          inDatabase:(CBLDatabase *)database {
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSString *a_type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];

    M_Workout *retval = [[M_Workout alloc] initWithDocument:[database untitledDocument]];
    retval.autosaves = YES;

    // meta
    retval.a_creation_date = a_creation_date;
    retval.a_creator = [ModelStore sharedInstance].username;
    retval.a_type = a_type;

    // properties
    retval.name = name;

    return retval;
}

+ (M_Workout *)editWorkout:(NSString *)name
                forWorkout:(CBLDocument *)doc
                inDatabase:(CBLDatabase *)database {
    M_Workout *retval = [[M_Workout alloc] initWithDocument:[database documentWithID:doc.documentID]];

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // META
    retval.a_creation_date = [doc.properties objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];
    retval.a_edit_date = [NSDate date];
    retval.a_type = [doc.properties objectForKey:@"a_type"];

    // PROPERTIES
    retval.name = [props objectForKey:@"name"];

    [latest putProperties:props error:nil];

    return retval;
}

@end
