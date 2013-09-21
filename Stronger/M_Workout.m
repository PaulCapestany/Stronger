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
{
    CBLLiveQuery* _workoutQuery;
}

// meta
@dynamic    created_at, updated_at;

// properties
@dynamic    name, owner_id;


- (id) initNewWithName:(NSString *)name inModelStore:(ModelStore *)modelStore
{
    self = [super initWithNewDocumentInDatabase: modelStore.database];
    if (self) {
        [self setupType: @"workout"];
        [self setValue: modelStore.username ofProperty: @"owner_id"];
        self.name = name;
    }
    return self;
}


- (M_Workout *)createWorkoutWithName:(NSString *)name {
    return [[M_Workout alloc] initNewWithName:name inModelStore:self.modelStore];
}


- (CBLLiveQuery*) workoutQuery {
    if (!_workoutQuery) {
        CBLQuery* query = [[self.database viewNamed: @"workouts"] query];
        _workoutQuery = [query asLiveQuery];
    }
    return _workoutQuery;
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
