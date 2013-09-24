//
//  M_ExercisesInWorkout.m
//  Workouts
//
//  Created by Paul Capestany on 10/21/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Exercise.h"
#import "ModelStore.h"
#import <CouchbaseLite/CBLModelFactory.h>

@implementation M_Exercise

// meta
@dynamic    created_at, updated_at;

// properties
@dynamic    name, belongs_to_workout_id, owner_id;

+ (CBLQuery*) exerciseQuery {
    CBLQuery* query = [[[ModelStore sharedInstance].database viewNamed: @"exercises"] query];
    return query;
}

+ (M_Exercise *)createExercise:(NSString *)name
         belongs_to_workout_id:(M_Workout *)belongs_to_workout_id
{
    return [[M_Exercise alloc] initNewWithName:name belongs_to_workout_id:belongs_to_workout_id];
}

- (id) initNewWithName:(NSString *)name belongs_to_workout_id:(M_Workout *)belongs_to_workout_id
{
    self = [super initWithNewDocumentInDatabase: [ModelStore sharedInstance].database];
    if (self) {
        [self setupType: @"exercise"];
        [self setValue: [ModelStore sharedInstance].username ofProperty: @"owner_id"];
        self.name = name;
        self.belongs_to_workout_id = belongs_to_workout_id;
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

