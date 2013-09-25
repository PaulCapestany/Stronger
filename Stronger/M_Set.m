//
//  M_Set.m
//  Workouts
//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "M_Set.h"
#import "ModelStore.h"
#import <CouchbaseLite/CBLModelFactory.h>

@implementation M_Set

// meta
@dynamic    created_at, updated_at;

// properties
@dynamic    weight, reps, belongs_to_exercise_id, created_by;

#pragma mark - Class functions

+ (CBLQuery*) setsQuery {
    CBLQuery* query = [[[ModelStore sharedInstance].database viewNamed: @"sets"] query];
    return query;
}

+ (M_Set *)createSetWithWeight:(NSNumber *)weight
                          reps:(NSNumber *)reps
        belongs_to_exercise_id:(M_Exercise *)belongs_to_exercise_id
{
    return [[M_Set alloc] initNewSetWithWeight:weight reps:reps belongs_to_exercise_id:belongs_to_exercise_id];
}

- (id)initNewSetWithWeight:(NSNumber *)weight
                      reps:(NSNumber *)reps
    belongs_to_exercise_id:(M_Exercise *)belongs_to_exercise_id
{
    self = [super initWithNewDocumentInDatabase: [ModelStore sharedInstance].database];
    if (self) {
        [self setupType: @"set"];
        [self setValue: [ModelStore sharedInstance].username ofProperty: @"created_by"];
        self.weight = weight;
        self.reps = reps;
        self.belongs_to_exercise_id = belongs_to_exercise_id;
    }
    return self;
}


- (bool) editable {
    NSString* username = self.modelStore.username;
    return [self.created_by isEqualToString: username];
}


- (bool) owned {
    NSString* username = self.modelStore.username;
    return [self.created_by isEqualToString: username];
}

@end
