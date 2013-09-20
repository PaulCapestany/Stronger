//
//  ChatStore.h
//  CouchChat
//
//  Created by Jens Alfke on 12/18/12.
//  Copyright (c) 2012 Couchbase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>
@class M_Workout, UserProfile;


/** Chat interface to a CouchbaseLite database. This is the root of the object model. */
@interface ModelStore : NSObject

- (id) initWithDatabase: (CBLDatabase*)database;

+ (ModelStore*) sharedInstance;

@property (readonly) CBLDatabase* database;

// WORKOUTS:

- (M_Workout*) newChatWithTitle: (NSString*)title;

// USERS:

/** The local logged-in user */
@property (nonatomic, readonly) UserProfile* user;

/** The local logged-in user's username. */
@property (nonatomic, copy) NSString* username;

/** Gets a UserProfile for a user given their username. */
- (UserProfile*) profileWithUsername: (NSString*)username;

- (void) setMyProfileName: (NSString*)name nick: (NSString*)nick;

@property (readonly) CBLQuery* allUsersQuery;
@property (readonly) NSArray* allOtherUsers;    /**< UserProfile objects of other users */

@end
