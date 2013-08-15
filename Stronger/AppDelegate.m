//
//  AppDelegate.m
//  Stronger
//
//  Created by Paul Capestany on 6/26/13.
//  Copyright (c) 2013 Paul Capestany. All rights reserved.
//

#import "AppDelegate.h"
#import <CouchbaseLite/CouchbaseLite.h>
#import <CouchbaseLite/CBLJSON.h>

@implementation AppDelegate

@synthesize database, _pull, _push, settingsDoc;

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Startup
//////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LogFunc;
    
    PDDebugger *debugger = [PDDebugger defaultInstance];
    // Enable Network debugging, and automatically track network traffic that comes through any classes that NSURLConnectionDelegate methods.
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    // Enable Core Data debugging, and broadcast the main managed object context.
    [debugger enableCoreDataDebugging];
//    [debugger addManagedObjectContext:self.managedObjectContext withName:@"Twitter Test MOC"];
    
    // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
    // Choose a few UIView key paths to display as attributes of the dom nodes
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque", @"accessibilityLabel", @"text"]];
    
    // Connect to a specific host
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    // Or auto connect via bonjour discovery
    //[debugger autoConnect];
    // Or to a specific ponyd bonjour service
    //[debugger autoConnectToBonjourServiceNamed:@"MY PONY"];
    
    // Enable remote logging to the DevTools Console via PDLog()/PDLogObjects().
    [debugger enableRemoteLogging];
    
    //    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    //    [TestFlight takeOff:@"d78a9123-5630-4228-96ba-03186e93b300"];
    
    LogDebug(@"Setting up database...");
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    // Open the database, creating it on the first run:
    NSError *error;
    self.database = [[CBLManager sharedInstance] createDatabaseNamed:@"stronger"
                                                               error:&error];
    if (!self.database) [self showAlert:@"Couldn't open database" error:error fatal:YES];
    
    [self executeMapBlocks];
    
    // TODO: need to create login screen
    NSArray *repls = [self.database replicateWithURL:[NSURL URLWithString:@"http://pac.macminicolo.net:4984/stronger"] exclusively:YES];
    if (repls) {
        _pull = [repls objectAtIndex:0];
        _push = [repls objectAtIndex:1];
        
        _pull.continuous = YES;
        _push.continuous = YES;
        
        _pull.persistent = YES;
        _push.persistent = YES;
        
        NSNotificationCenter *nctr = [NSNotificationCenter defaultCenter];
        [nctr addObserver:self selector:@selector(replicationProgress:)
                     name:kCBLReplicationChangeNotification object:_pull];
        [nctr addObserver:self selector:@selector(replicationProgress:)
                     name:kCBLReplicationChangeNotification object:_push];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    LogFunc;
    PDLog(@"PONY applicationWillResignActive");               // This logs a simple string to the console output.
    PDLogObjects(self);                  // This logs an introspectable version of "self" to the console.
    PDLogObjects(@"self.database:", self.database);  // Combination of text and introspectable object.
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    LogFunc;
    PDLog(@"PONY applicationDidEnterBackground");               // This logs a simple string to the console output.
    //LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"Func",4,[NSString stringWithUTF8String:__FUNCTION__],@"")
    //webpagehelper://com.apple.AppleScript.WebpageHelper?action=1
//    NSString *logThis = [NSString stringWithFormat:@"%s:%d\n%s", __FILE__, __LINE__, __FUNCTION__];
//    PDLog(logThis);
    
//    PDLogObjects(@"%s:%d %@", __FILE__, __LINE__, __FUNCTION__);
    
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
    PDLog(@"PONY applicationDidBecomeActive");               // This logs a simple string to the console output.

   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    LogFunc;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

////////////////////////////////////////////////////////////////////////////////////////////
//#pragma mark - Map Views
////////////////////////////////////////////////////////////////////////////////////////////

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
    [[database viewNamed:@"workouts"] setMapBlock:MAPBLOCK({
        id date = [doc objectForKey:@"a_creation_date"];
        if ([[doc objectForKey:@"a_type"] isEqualToString:@"Workout"]) emit([NSArray arrayWithObjects:date, nil], doc);
    }) reduceBlock:nil version:kMapFunctionVersion];
    
    ///////////////
    // EXERCISES //
    ///////////////
    
    LogDebug(@"Set up exercises map view");
    // TODO: create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc)
    // ???: CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it
    [[database viewNamed:@"exercises"] setMapBlock:MAPBLOCK({
        id date = [doc objectForKey:@"a_creation_date"];
        if ([[doc objectForKey:@"a_type"] isEqualToString:@"Exercise"]) emit([NSArray arrayWithObjects:[doc objectForKey:@"belongs_to_workout_id"], date, nil], doc);
    }) reduceBlock:nil version:kMapFunctionVersion];
    
    //////////
    // SETS //
    //////////
    
    LogDebug(@"Set up sets map view");
    // Create a 'view' containing list items sorted by date:
    [[database viewNamed:@"sets"] setMapBlock:MAPBLOCK({
        id date = [doc objectForKey:@"a_creation_date"];
        if ([[doc objectForKey:@"a_type"] isEqualToString:@"Set"]) emit([NSArray arrayWithObjects:[doc objectForKey:@"belongs_to_exercise_id"], date, nil], doc);
    }) reduceBlock:nil version:kMapFunctionVersion];
    
    // create the settings doc, only if it does not already exist
    // UPCOMING: need to "merge" the settings doc if a previous one already existed...
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Settings Set"] == NULL) {
        LogDebug(@"Creating settings doc");
        settingsDoc = [M_Settings createSettingsInDatabase:database];
        [[NSUserDefaults standardUserDefaults] setObject:@"yup" forKey:@"Settings Set"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        settingsDoc = [[M_Settings alloc] initWithDocument:[database documentWithID:@"Settings"]];
        //        settingsDoc.autosaves = YES;
    }
    
    /**********************
    * VALIDATION FUNCTION *
    **********************/

    // and a validation function requiring parseable dates:
    [database defineValidation: @"a_creation_date" asBlock: VALIDATIONBLOCK({
        if (newRevision.isDeleted)
            return YES;
        id date = [newRevision.properties objectForKey: @"a_creation_date"];
        if (date && ! [CBLJSON dateWithJSONObject: date]) {
            context.errorMessage = [@"invalid date " stringByAppendingString: [date description]];
            return NO;
        }
        return YES;
    })];
}

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Other
//////////////////////////////////////////////////////////////////////////////////////////

- (void)replicationProgress:(NSNotificationCenter *)n {
    LogFunc;
    
    // TODO: find out why the activityIndicator is always active...
//    if (_pull.mode == kCBLReplicationActive || _push.mode == kCBLReplicationActive) {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    } else {
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    }
}

// Display an error alert, without blocking.
// If 'fatal' is true, the app will quit when it's pressed.
- (void)showAlert:(NSString *)message error:(NSError *)error fatal:(BOOL)fatal {
    LogFunc;
    
    if (error) {
        message = [NSString stringWithFormat:@"%@\n\n%@", message, error.localizedDescription];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:(fatal ? @"Fatal Error" : @"Error")
                                                    message:message
                                                   delegate:(fatal ? self : nil)
                                          cancelButtonTitle:(fatal ? @"Quit" : @"Sorry")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    LogFunc;
    
    exit(0);
}

- (void)dealloc {
    LogFunc;
    
    NSNotificationCenter *nctr = [NSNotificationCenter defaultCenter];
    if (_pull) {
        [nctr removeObserver:self name:nil object:_pull];
        _pull = nil;
    }
    if (_push) {
        [nctr removeObserver:self name:nil object:_push];
        _push = nil;
    }
}


@end
