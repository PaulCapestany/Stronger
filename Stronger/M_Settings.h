//
//  M_Settings.h
//  Workouts
//
//  Created by Paul Capestany on 10/29/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface M_Settings : CBLModel

+ (M_Settings *)createSettingsInDatabase:(CBLDatabase *)database;

+ (M_Settings *)editSettings:(CBLDocument *)doc
               workout_order:(NSArray *)workout_order
                  inDatabase:(CBLDatabase *)database;

//+ (M_Settings*) theSettingsInDatabase:(CBLDatabase *) database;

// standard meta-data
//@property (copy) NSArray* channels;
@property (retain) NSDate *a_creation_date;
@property (retain) NSString *a_creator;
@property (retain) NSDate *a_edit_date;
@property (retain) NSString *a_type;

// ???: I think these need to actually be `M_Workout` models?
// properties unique to Workouts
@property (copy) NSArray *workout_order;

@end
