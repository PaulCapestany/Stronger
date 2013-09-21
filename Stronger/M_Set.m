//
//  M_Set.m
//  Workouts
//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Set.h"
#import <CouchbaseLite/CBLJSON.h>
#import "ModelStore.h"

@implementation M_Set

// meta
@dynamic    a_creation_date, a_creator, a_edit_date, type;

// properties
@dynamic    weight, reps, belongs_to_exercise_id;

#pragma mark - Class functions

+ (M_Set *)createSetWithWeight:(NSNumber *)weight
                          reps:(NSNumber *)reps
        belongs_to_exercise_id:(M_Exercise *)belongs_to_exercise_id
{
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSDate *a_edit_date = [NSDate date];
    NSString *type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];

    M_Set *retval = [[M_Set alloc] initWithDocument:[[ModelStore sharedInstance].database untitledDocument]];
    retval.autosaves = YES;

    // meta
    retval.a_creation_date = a_creation_date;
    retval.a_creator = [ModelStore sharedInstance].username;
    retval.a_edit_date = a_edit_date;
    retval.type = type;

    // properties
    retval.weight = weight;
    retval.reps = reps;
    retval.belongs_to_exercise_id = belongs_to_exercise_id;

    return retval;
}

+ (M_Set *)editSetWithWeight:(NSNumber *)weight
                        reps:(NSNumber *)reps
                      forSet:(CBLDocument *)doc
{
    M_Set *retval = [M_Set modelForDocument:doc];

    NSDate *a_edit_date = [NSDate date];

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // META
    retval.a_creation_date = [doc.properties objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];
    retval.a_edit_date = a_edit_date;
    retval.type = [doc.properties objectForKey:@"type"];

    // PROPERTIES
    retval.weight = [props objectForKey:@"weight"];
    retval.reps = [props objectForKey:@"reps"];
    retval.belongs_to_exercise_id = [props objectForKey:@"belongs_to_exercise_id"];

    [latest putProperties:props error:nil];

    return retval;
}

@end
