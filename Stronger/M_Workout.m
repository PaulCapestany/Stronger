//
//  Workout.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Workout.h"
#import "ModelStore.h"
#import <CouchbaseLite/CBLModelFactory.h>

@implementation M_Workout

// meta
@dynamic    created_at, updated_at;

// properties
@dynamic    name, owner_id;


+ (CBLQuery*) workoutsQuery {
    CBLQuery* query = [[[ModelStore sharedInstance].database viewNamed: @"workouts"] query];
    return query;
}

+ (M_Workout *)createWorkoutWithName:(NSString *)name {
    return [[M_Workout alloc] initNewWorkoutWithName:name];
}


- (id) initNewWorkoutWithName:(NSString *)name
{
    self = [super initWithNewDocumentInDatabase: [ModelStore sharedInstance].database];
    if (self) {
        [self setupType: @"workout"];
        [self setValue: [ModelStore sharedInstance].username ofProperty: @"owner_id"];
        self.name = name;
    }
    return self;
}


- (bool) editable {
    NSString* username = self.modelStore.username;
    return [self.owner_id isEqualToString: username];
}


- (bool) owned {
    NSString* username = self.modelStore.username;
    return [self.owner_id isEqualToString: username];
}


@end
