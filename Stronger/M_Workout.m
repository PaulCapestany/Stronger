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
@dynamic    a_creation_date, a_creator, a_edit_date, type;

// properties
@dynamic    name;

+ (M_Workout *)createWorkoutWithName:(NSString *)name
{
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSString *type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];

    M_Workout *retval = [[M_Workout alloc] initWithDocument:[[ModelStore sharedInstance].database untitledDocument]];
    retval.autosaves = YES;

    // meta
    retval.a_creation_date = a_creation_date;
    retval.a_creator = [ModelStore sharedInstance].username;
    retval.type = type;

    // properties
    retval.name = name;

    return retval;
}

+ (M_Workout *)editWorkout:(NSString *)name
                forWorkout:(CBLDocument *)doc
{
    M_Workout *retval = [[M_Workout alloc] initWithDocument:[[ModelStore sharedInstance].database documentWithID:doc.documentID]];

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // META
    retval.a_creation_date = [doc.properties objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];
    retval.a_edit_date = [NSDate date];
    retval.type = [doc.properties objectForKey:@"type"];

    // PROPERTIES
    retval.name = [props objectForKey:@"name"];

    [latest putProperties:props error:nil];

    return retval;
}

@end
