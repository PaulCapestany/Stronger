//
//  AppDelegate.m
//  Stronger
//
//  Created by Paul Capestany on 6/26/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import "AppDelegate.h"
#import "ModelStore.h"
#import "SyncManager.h"
#import "PersonaController+UIKit.h"
#import <CouchbaseLite/CouchbaseLite.h>

#define kServerDBURLString @"https://pac.macminicolo.net:4984/ptest"

AppDelegate* gAppDelegate;

@interface AppDelegate () <SyncManagerDelegate, PersonaControllerDelegate>
@end

@implementation AppDelegate
{
    CBLDatabase* _database;
    SyncManager* _syncManager;
    PersonaController* _personaController;
    bool _loggingIn;
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Startup
//////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    gAppDelegate = self;

    LogFunc;
    
#if ENABLE_PONY
    PDDebugger *debugger = [PDDebugger defaultInstance];
    // Enable Network debugging, and automatically track network traffic that comes through any classes that NSURLConnectionDelegate methods.
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    // Enable Core Data debugging, and broadcast the main managed object context..
    [debugger enableCoreDataDebugging];
//    [debugger addManagedObjectContext:self.managedObjectContext withName:@"Twitter Test MOC"];
    
    // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
    // Choose a few UIView key paths to display as attributes of the dom nodes
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque", @"accessibilityLabel", @"text"]];
    
    // Connect to a specific host
    [debugger connectToURL:[NSURL URLWithString:@"ws://192.168.1.2:9000/device"]];
    // Or auto connect via bonjour discovery
    //[debugger autoConnect];
    // Or to a specific ponyd bonjour service
    //[debugger autoConnectToBonjourServiceNamed:@"MY PONY"];
    
    // Enable remote logging to the DevTools Console via PDLog()/PDLogObjects().
    [debugger enableRemoteLogging];
#endif
    
    //    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    //    [TestFlight takeOff:@"d78a9123-5630-4228-96ba-03186e93b300"];
    
    LogDebug(@"Setting up database...");
    
    // Open the database, creating it on the first run:
    NSError *error;
    _database = [[CBLManager sharedInstance] createDatabaseNamed:@"stronger"
                                                               error:&error];
    if (!_database) {
        [self showAlert:@"Couldn't open database" error:error fatal:YES];
    }
    
    _modelStore = [[ModelStore alloc] initWithDatabase: _database];
    
    [self setupSync];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    LogFunc;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    LogFunc;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    LogFunc;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    LogFunc;
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    LogFunc;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - SYNC & LOGIN:




- (void) setupSync {
    LogFunc;
    
    _syncManager = [[SyncManager alloc] initWithDatabase: _database];
    _syncManager.delegate = self;
    // Configure replication:
    _syncManager.continuous = YES;
    _syncManager.syncURL = [NSURL URLWithString: kServerDBURLString];
}




- (void) syncManagerProgressChanged: (SyncManager*)manager {
    LogFunc;
    
    if (_loggingIn) {
        CBLReplication* repl = manager.replications[0];
        // Pick up my username from the replication, on the first sync:
        NSString* username = repl.personaEmailAddress;
        if (!username)
            username = repl.credential.user;
        if (username) {
            LogDebug(@"Chat username =", username);
            _modelStore.username = username;
            _loggingIn = false;
        }
    }
}




- (bool) syncManagerShouldPromptForLogin: (SyncManager*)manager {
    LogFunc;
    
    // Display Persona login panel, not the default username/password one:
    if (!_personaController) {
        _loggingIn = true;
        _personaController = [[PersonaController alloc] init];
        NSArray* replications = _syncManager.replications;
        if (replications.count > 0)
            _personaController.origin = [replications[0] personaOrigin];
        _personaController.delegate = self;
        [_personaController presentModalInController: self.window.rootViewController];
    }
    return false;
}




- (void) personaControllerDidCancel: (PersonaController*) personaController {
    LogFunc;
    
    [_personaController.viewController dismissViewControllerAnimated: YES completion: NULL];
    _personaController = nil;
}



- (void) personaController: (PersonaController*) personaController
         didFailWithReason: (NSString*) reason
{
    LogFunc;
    
    [self personaControllerDidCancel: personaController];
}



- (void) personaController: (PersonaController*) personaController
   didSucceedWithAssertion: (NSString*) assertion
{
    LogFunc;
    
    [self personaControllerDidCancel: personaController];
    for (CBLReplication* repl in _syncManager.replications) {
        [repl registerPersonaAssertion: assertion];
    }
}


#pragma mark - ALERT:


// Display an error alert, without blocking.
// If 'fatal' is true, the app will quit when it's pressed.


- (void)showAlert: (NSString*)message error: (NSError*)error fatal: (BOOL)fatal {
    LogFunc;
    
    if (error) {
        message = [NSString stringWithFormat: @"%@\n\n%@", message, error.localizedDescription];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: (fatal ? @"Fatal Error" : @"Error")
                                                    message: message
                                                   delegate: (fatal ? self : nil)
                                          cancelButtonTitle: (fatal ? @"Quit" : @"Sorry")
                                          otherButtonTitles: nil];
    [alert show];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    LogFunc;
    
    exit(0);
}


- (void)dealloc {
    LogFunc;
}


@end
