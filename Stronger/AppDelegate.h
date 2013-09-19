//
//  AppDelegate.h
//  Stronger
//
//  Created by Paul Capestany on 6/26/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M_Settings.h"

@class CBLDatabase, CBLReplication;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, strong) CBLDatabase *database;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, retain) M_Settings *settingsDoc;

@property (strong, nonatomic) UIWindow *window;

- (void)showAlert:(NSString *)message error:(NSError *)error fatal:(BOOL)fatal;

@end

extern AppDelegate* gAppDelegate;
