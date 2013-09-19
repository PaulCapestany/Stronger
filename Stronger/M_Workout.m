//
//  Workout.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Workout.h"
#import <CouchbaseLite/CBLJSON.h>
#import "AppDelegate.h"

@implementation M_Workout

// meta
@dynamic    a_creation_date, a_creator, a_edit_date, a_type; // channels

// properties
@dynamic    name;

+ (M_Workout *)createWorkoutWithName:(NSString *)name
                          inDatabase:(CBLDatabase *)database {
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSString *a_type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];
//	NSString *documentID = [NSString stringWithFormat:@"%@~%@~%@", [CBLJSON JSONObjectWithDate:[NSDate date]], a_type, name];
    NSString *documentID = [NSString stringWithFormat:@"%@~%@", [CBLJSON JSONObjectWithDate:[NSDate date]], a_type];

    M_Workout *retval = [[M_Workout alloc] initWithDocument:[database documentWithID:documentID]];
    retval.autosaves = YES;

    // meta
//    retval.channels = [NSArray arrayWithObjects:@"edolvice_channel", nil];
    retval.a_creation_date = a_creation_date;
    retval.a_creator = gAppDelegate.username;
    retval.a_type = a_type;

    // properties
    retval.name = name;

    return retval;
}

+ (M_Workout *)editWorkout:(NSString *)name
                forWorkout:(CBLDocument *)doc
                inDatabase:(CBLDatabase *)database {
    M_Workout *retval = [[M_Workout alloc] initWithDocument:[database documentWithID:doc.documentID]];
    //retval.autosaves = YES;

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // META
//    retval.channels = [doc.properties objectForKey:@"channels"];
    retval.a_creation_date = [doc.properties objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];
    retval.a_edit_date = [NSDate date];
    retval.a_type = [doc.properties objectForKey:@"a_type"];

    // PROPERTIES
    retval.name = [props objectForKey:@"name"];

    [latest putProperties:props error:nil];

    //    LogVerbose(@"doc.properties = %@ \ndoc.userProperties = %@ \nretval.document.properties = %@ \nretval.document.userProperties = %@", doc.properties, doc.userProperties, retval.document.properties, retval.document.userProperties);

    return retval;
}

@end
