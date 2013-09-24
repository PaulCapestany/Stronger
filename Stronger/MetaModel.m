//
//  MetaModel.m
//  Stronger
//
//  Created by Paul Capestany on 9/20/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import "MetaModel.h"
#import "ModelStore.h"

@implementation MetaModel

@dynamic visible_to, created_at, updated_at;


- (id) initWithDocument: (CBLDocument*)document {
    self = [super initWithDocument: document];
    if (self) {
        self.autosaves = true;
    }
    return self;
}


- (void) setupType: (NSString*)type {
    [self setValue: type ofProperty: @"type"];
    self.visible_to = @[@"creator"];
    self.created_at = self.updated_at = [NSDate date];
}


- (NSDictionary*) propertiesToSave {
    if (self.needsSave) {
        // Bump the updated_at date when saving:
        NSDate* now = [NSDate date];
        self.updated_at = now;
        if (!self.created_at)
            self.created_at = now;
    }
    return [super propertiesToSave];
}


- (ModelStore*) modelStore {
    return [ModelStore sharedInstance];
}


- (bool) editable {
    return false; // abstract
}


- (bool) owned {
    return false; // abstract
}


@end
