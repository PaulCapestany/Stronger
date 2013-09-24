//
//  ChatStore.m
//  CouchChat
//
//  Created by Jens Alfke on 12/18/12.
//  Copyright (c) 2012 Couchbase. All rights reserved.
//

#import "ModelStore.h"
#import "UserProfile_Private.h"
#import <CouchbaseLite/CBLModelFactory.h>
#import <CouchbaseLite/CBLJSON.h>


static ModelStore* sInstance;


@implementation ModelStore
{
    CBLView* _usersView;
    CBLLiveQuery* _chatModDatesQuery;
}


@synthesize username=_username;

- (id) initWithDatabase: (CBLDatabase*)database {
    LogFunc;

    self = [super init];
    if (self) {
        NSAssert(!sInstance, @"Cannot create more than one ModelStore");
        sInstance = self;
        _database = database;
        _username = [[NSUserDefaults standardUserDefaults] stringForKey: @"UserName"];
        
        [_database.modelFactory registerClass: [UserProfile class] forDocumentType: @"profile"];

        [self executeMapBlocks];
    }
    return self;
}

- (void)executeMapBlocks {
    LogFunc;
    
    /*
     
     MAP VIEW SETUP
     --------------
     Note: the actual map function for a view runs en masse for each document only on first query,
     OR if the version # of the function has changed
     Otherwise, the map function is only called each time a document has been revised.
     
     */
    
    // ???: change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)?
    
    //////////////
    // WORKOUTS //
    //////////////
    
    LogDebug(@"Set up workouts map view");
    // TODO: create "sortable" view for Workouts (substitute "a_creation_date" with sort numbers from settings doc)
    [[_database viewNamed:@"workouts"] setMapBlock:MAPBLOCK({
        id date = [doc objectForKey:@"created_at"];
        if ([[doc objectForKey:@"type"] isEqualToString:@"workout"]) emit([NSArray arrayWithObjects:date, nil], doc);
    }) reduceBlock:nil version:@"0.7"];
    
    ///////////////
    // EXERCISES //
    ///////////////
    
    LogDebug(@"Set up exercises map view");
    // TODO: create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc)
    // ???: CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it
    [[_database viewNamed:@"exercises"] setMapBlock:MAPBLOCK({
        id date = [doc objectForKey:@"a_creation_date"];
        if ([[doc objectForKey:@"type"] isEqualToString:@"Exercise"]) emit([NSArray arrayWithObjects:[doc objectForKey:@"belongs_to_workout_id"], date, nil], doc);
    }) reduceBlock:nil version:@"0.6"];
    
    //////////
    // SETS //
    //////////
    
    // TODO: make date grouping logic smarter with `compare` method
    // ⤹ EXAMPLE ⤵
    // if ([someDate compare:anotherDate] == NSOrderedAscending)
    LogDebug(@"Set up sets map view");
    // Create a 'view' containing list items sorted by date:
    [[_database viewNamed:@"sets"] setMapBlock:MAPBLOCK({
        id date = [doc objectForKey:@"a_creation_date"];
        NSDate* dateObject = [CBLJSON dateWithJSONObject:date];
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"dd"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString* dayString = [dateFormatter stringFromDate:dateObject];
        
        if ([[doc objectForKey:@"type"] isEqualToString:@"Set"]) emit([NSArray arrayWithObjects:[doc objectForKey:@"belongs_to_exercise_id"], date, dayString, nil], doc);
    }) reduceBlock:nil version:@"1.1"];
    
    
    /********
    * USERS *
    ********/

    // View for getting user profiles by name
    _usersView = [_database viewNamed: @"usersByName"];
    [_usersView setMapBlock: MAPBLOCK({
        if ([doc[@"type"] isEqualToString: @"profile"]) {
            NSString* name = doc[@"nick"] ?: [UserProfile usernameFromDocID: doc[@"_id"]];
            if (name)
                emit(name.lowercaseString, name);
        }
    }) version: @"1.1"];
}



- (void)dealloc
{
    LogFunc;
}



+ (ModelStore*) sharedInstance {
    LogFunc;

    return sInstance;
}



#pragma mark - USERS:



- (void) setUsername:(NSString *)username {
    LogFunc;

    if (![username isEqualToString: _username]) {
        LogDebug(@"Setting chat username to", username);
        _username = [username copy];
        [[NSUserDefaults standardUserDefaults] setObject: username forKey: @"UserName"];

        UserProfile* myProfile = [self profileWithUsername: _username];
        if (!myProfile) {
            myProfile = [UserProfile createInDatabase: _database
                                         withUsername: _username];
            LogDebug(@"Created user profile", myProfile);
        }
    }
}




- (UserProfile*) user {
    LogFunc;

    if (!_username)
        return nil;
    UserProfile* user = [self profileWithUsername: _username];
    if (!user) {
        user = [UserProfile createInDatabase: _database
                                withUsername: _username];
    }
    return user;
}




- (UserProfile*) profileWithUsername: (NSString*)username {
    LogFunc;

    NSString* docID = [UserProfile docIDForUsername: username];
    CBLDocument* doc = [self.database documentWithID: docID];
    if (!doc.currentRevisionID)
        return nil;
    return [UserProfile modelForDocument: doc];
}



- (void) setMyProfileName: (NSString*)name nick: (NSString*)nick {
    LogFunc;

    UserProfile* myProfile = [self profileWithUsername: self.username];
    [myProfile setName: name nick: nick];
}




- (CBLQuery*) allUsersQuery {
    LogFunc;

    return [_usersView query];
}



- (NSArray*) allOtherUsers {
    LogFunc;

    NSMutableArray* users = [NSMutableArray array];
    for (CBLQueryRow* row in self.allUsersQuery.rows.allObjects) {
        UserProfile* user = [UserProfile modelForDocument: row.document];
        if (![user.username isEqualToString: _username])
            [users addObject: user];
    }
    return users;
}



@end
