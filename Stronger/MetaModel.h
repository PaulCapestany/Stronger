//
//  MetaModel.h
//  Stronger
//
//  Created by Paul Capestany on 9/20/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@class ModelStore;

@interface MetaModel : CBLModel

@property (readonly) ModelStore* modelStore;

//@property (readonly) NSString* owner_id;

@property (strong) NSDate* created_at;
@property (strong) NSDate* updated_at;

@property (readonly) bool editable;
@property (readonly) bool owned;

@end


@interface MetaModel (Private)
- (void) setupType: (NSString*)type;
@end