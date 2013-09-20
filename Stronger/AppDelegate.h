//
//  AppDelegate.h
//  Stronger
//
//  Created by Paul Capestany on 6/26/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelStore;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly) ModelStore* modelStore;

- (void)showAlert:(NSString *)message error:(NSError *)error fatal:(BOOL)fatal;

@end

extern AppDelegate* gAppDelegate;
