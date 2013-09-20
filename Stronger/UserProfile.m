//
//  UserProfile.m
//  CouchChat
//
//  Created by Jens Alfke on 2/15/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "UserProfile.h"
#import "ModelStore.h"

@implementation UserProfile


+ (NSString*) docIDForUsername: (NSString*)username {
    LogFunc;

    return [@"profile:" stringByAppendingString: username];
}



+ (NSString*) usernameFromDocID: (NSString*)docID {
    LogFunc;

    return [docID substringFromIndex: 8];
}


@dynamic name, nick;




- (NSString*) username {
    LogFunc;

    return [self.class usernameFromDocID: self.document.documentID];
}




- (NSString*) email {
    LogFunc;

    NSString* email = [self getValueOfProperty: @"email"];
    if (!email) {
        // If no explicit email, assume the username is a valid email if it contains an "@":
        NSString* username = self.username;
        if ([username rangeOfString: @"@"].length > 0)
            email = username;
    }
    return email;
}




- (NSString*) displayName {
    LogFunc;

    return self.name ?: (self.nick ?: self.username);
}




- (bool) isMe {
    LogFunc;

    return [self.username isEqualToString: [[ModelStore sharedInstance] username]];
}



+ (UserProfile*) createInDatabase: (CBLDatabase*)database
                     withUsername: (NSString*)username
{
    LogFunc;

    NSString* docID = [self docIDForUsername: username];
    CBLDocument* doc = [database documentWithID: docID];
    UserProfile* profile = [UserProfile modelForDocument: doc];

    [profile setValue: @"profile" ofProperty: @"type"];

    NSString* nick = username;
    NSRange at = [username rangeOfString: @"@"];
    if (at.length > 0) {
        nick = [username substringToIndex: at.location];
        [profile setValue: username ofProperty: @"email"];
    }
    [profile setValue: nick ofProperty: @"nick"];

    NSError* error;
    if (![profile save: &error])
        return nil;
    return profile;
}




- (void) setName: (NSString*)name nick: (NSString*)nick {
    LogFunc;

    self.autosaves = true;
    [self setValue: name ofProperty: @"name"];
    [self setValue: nick ofProperty: @"nick"];
}



+ (NSString*) listOfNames: (id)userArrayOrSet {
    LogFunc;

    NSMutableString* names = [NSMutableString string];
    for (UserProfile* profile in userArrayOrSet) {
        if (!profile.isMe) {
            if (names.length > 0)
                [names appendString: @", "];
            [names appendString: profile.displayName];
        }
    }
    return names;
}


@end
