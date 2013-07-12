//
//  M_Settings.m
//  Workouts
//
//  Created by Paul Capestany on 10/29/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Settings.h"
#import <CouchbaseLite/CBLJSON.h>

@implementation M_Settings

// meta
@dynamic    a_creation_date, a_creator, a_edit_date, a_type; // channels

// properties
@dynamic    workout_order;

+ (M_Settings *)createSettingsInDatabase:(CBLDatabase *)database {
    // setup
    NSDate *a_creation_date = [NSDate date];
    NSString *a_type = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"M_" withString:@""];
    NSString *documentID = [NSString stringWithFormat:@"%@", a_type];

    M_Settings *retval = [[M_Settings alloc] initWithDocument:[database documentWithID:documentID]];
    retval.autosaves = YES;

    // meta
//    retval.channels = [NSArray arrayWithObjects:@"edolvice_channel", nil];
    retval.a_creation_date = a_creation_date;
//    retval.a_edit_date = [NSDate date];
    retval.a_creator = @"edolvice";
    retval.a_type = a_type;

    // properties
    retval.workout_order = nil;

    return retval;
}

// TODO: update all other CBLModels with similar edit logic
+ (M_Settings *)editSettings:(CBLDocument *)doc
               workout_order:(NSArray *)workout_order
                  inDatabase:(CBLDatabase *)database {
    M_Settings *retval = [[M_Settings alloc] initWithDocument:[database documentWithID:doc.documentID]];
    //retval.autosaves = YES;

    CBLRevision *latest = doc.currentRevision;
    NSMutableDictionary *props = [latest.properties mutableCopy];

    // EDITS
    NSDate *a_edit_date = [NSDate date];

    [props setObject:workout_order forKey:@"workout_order"];
    [props setObject:[CBLJSON JSONObjectWithDate:[NSDate date]] forKey:@"a_edit_date"];

    // META
//    retval.channels = [doc.properties objectForKey:@"channels"];
    retval.a_creation_date = [props objectForKey:@"a_creation_date"];
    retval.a_creator = [doc.properties objectForKey:@"a_creator"];    
    retval.a_edit_date = a_edit_date;
    retval.a_type = [props objectForKey:@"a_type"];

    // PROPERTIES
    retval.workout_order = workout_order;

    [latest putProperties:props error:nil];

    //    LogVerbose(@"doc.properties = %@ \ndoc.userProperties = %@ \nretval.document.properties = %@ \nretval.document.userProperties = %@", doc.properties, doc.userProperties, retval.document.properties, retval.document.userProperties);

    return retval;
}

//+ (M_Settings*) theSettingsInDatabase:(CBLDatabase *) database
//{
////
//    CBLDocument *settingsDoc = [database documentWithID:@"Settings"];
//    M_Settings *retval = [[M_Settings alloc] initWithDocument:settingsDoc];
//    //retval.autosaves = YES;
//
//    CBLRevision* latest = settingsDoc.currentRevision;
//    NSMutableDictionary* props = [latest.properties mutableCopy];
//
//    // EDITS
//    NSDate *a_edit_date = [NSDate date];
//
//    [props setObject:workout_order forKey:@"workout_order"];
//    [props setObject:[CBLJSON JSONObjectWithDate:[NSDate date]] forKey:@"a_edit_date"];
//
//    // META
//    retval.a_creation_date = [props objectForKey:@"a_creation_date"];
//    retval.a_edit_date = a_edit_date;
//    retval.a_type = [props objectForKey:@"a_type"];
//
//    // PROPERTIES
//    retval.workout_order = workout_order;
//
//    [latest putProperties:props];
//
//    //    LogVerbose(@"doc.properties = %@ \ndoc.userProperties = %@ \nretval.document.properties = %@ \nretval.document.userProperties = %@", doc.properties, doc.userProperties, retval.document.properties, retval.document.userProperties);
//
//    return retval;
//}

@end
