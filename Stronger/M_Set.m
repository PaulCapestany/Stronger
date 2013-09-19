//
//  M_Set.m
//  Workouts
//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Set.h"
#import <CouchbaseLite/CBLJSON.h>
#import "AppDelegate.h"

@implementation M_Set

// meta
@dynamic    a_creation_date, a_creator, a_edit_date, a_type; // channels

// properties
@dynamic    weight, reps, belongs_to_exercise_id;

#pragma mark - Class functions

+ (M_Set *)createSetWithWeight:(NSNumber *)weight
                          reps:(NSNumber *)reps
        belongs_to_exercise_id:(M_Exercise *)belongs_to_exercise_id
                    inDatabase:(CBLDatabase *)database {
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSDate *a_edit_date = [NSDate date];
    NSString *a_type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];
    NSString *documentID = [NSString stringWithFormat:@"%@~%@", [CBLJSON JSONObjectWithDate:[NSDate date]], a_type];

    M_Set *retval = [[M_Set alloc] initWithDocument:[database documentWithID:documentID]];
    retval.autosaves = YES;

    // meta
//    retval.channels = [NSArray arrayWithObjects:@"edolvice_channel", nil];
    retval.a_creation_date = a_creation_date;
    retval.a_creator = gAppDelegate.username;
    retval.a_edit_date = a_edit_date;
    retval.a_type = a_type;

    // properties
    retval.weight = weight;
    retval.reps = reps;
    retval.belongs_to_exercise_id = belongs_to_exercise_id;

    return retval;
}

+ (M_Set *)editSetWithWeight:(NSNumber *)weight
                        reps:(NSNumber *)reps
                      forSet:(CBLDocument *)doc
                  inDatabase:(CBLDatabase *)database {
//    M_Set *retval = [[M_Set alloc] initWithDocument:[database documentWithID:doc.documentID]];
    M_Set *retval = [M_Set modelForDocument:doc];
    //retval.autosaves = YES;

    NSDate *a_edit_date = [NSDate date];

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // META
//    retval.channels = [doc.properties objectForKey:@"channels"];
    retval.a_creation_date = [doc.properties objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];
    retval.a_edit_date = a_edit_date;
    retval.a_type = [doc.properties objectForKey:@"a_type"];

    // PROPERTIES
    retval.weight = [props objectForKey:@"weight"];
    retval.reps = [props objectForKey:@"reps"];
    retval.belongs_to_exercise_id = [props objectForKey:@"belongs_to_exercise_id"];

    [latest putProperties:props error:nil];

//    LogVerbose(@"doc.properties = %@ \ndoc.userProperties = %@ \nretval.document.properties = %@ \nretval.document.userProperties = %@", doc.properties, doc.userProperties, retval.document.properties, retval.document.userProperties);

    return retval;
}

@end
