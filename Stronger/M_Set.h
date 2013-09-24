//
//  M_Set.h
//  Workouts
//
//  Created by Paul Capestany on 10/20/12.
//  Copyright (c) 2012 Paul Capestany. All rights reserved.
//

#import "MetaModel.h"

@class M_Exercise;

// M_Set belongs to M_Exercise which belongs to M_Workout

@interface M_Set : MetaModel

+ (CBLQuery*) setsQuery;

+ (M_Set *)createSetWithWeight:(NSNumber *)weight
                          reps:(NSNumber *)reps
        belongs_to_exercise_id:(M_Exercise *)belongs_to_exercise_id;

@property (copy) NSNumber *weight;
@property (copy) NSNumber *reps;
@property (assign) M_Exercise *belongs_to_exercise_id;
@property (readonly) NSString* created_by;

@end
