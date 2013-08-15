/*
 AppConstants.h
 */

#import "LoggerClient.h"
#import "vendor/PonyDebugger/ObjC/PonyDebugger/PonyDebugger.h"

// **************
// * TODOS, ETC *
// **************

// TODO: create users for app

// ???: find out if I need to change how I'm doing the IDs for each doc

// TODO: add file for passwords/etc to .gitignore

// ???: look into `UICollectionView`

// TODO: build database of exercises/machines

// ???: explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`?

// *************
// * CONSTANTS *
// *************

// TODO: reimplement constants once I've sorted out auth stuff
//#define     kCouchDBName       @"jim-app"
//#define     kRemoteSyncGateway @"http://pac.macminicolo.net:4984/"
//#define     kRemoteSyncUrl     kRemoteSyncGateway kCouchDBName

// ***********
// * LOGGING *
// ***********

/*

 Log Levels
 ----------
 NSLogger log levels start a 0, the bigger the number,
 the more specific / detailed the trace is meant to be
 
 0 — super important
 1 — less important
 2 ...
 
 ⤹ should correspond ⤴
 
 Potential levels...
 -------------------
 ERROR
 REPORT
 FUNCTIONS
 GENERAL LOG
 DEBUG?
 Warn?
 
 Potential tags...
 -----------------
 DATA
 ACTION
 ...
 
*/

#ifdef DEBUG
    #define LogFunc   LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"Func",4,[NSString stringWithUTF8String:__FUNCTION__],@"")
    #define LogDebug(...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"Debug",0,__VA_ARGS__)
    #define LogAction(...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"Action",0,__VA_ARGS__)
    #define LogVerbose(...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"Verbose",1,__VA_ARGS__)
    #define LogErr(...)    LogMessageF(__FILE__,__LINE__,__FUNCTION__,@"Error",0,__VA_ARGS__)
#else
    #define LogFunc(...)     do{}while(0)
    #define LogDebug(...)    do{}while(0)
    #define LogAction(...)   do{}while(0)
    #define LogVerbose(...)  do{}while(0)
    #define LogErr(...)    do{}while(0)
#endif

// **********************
// * MAP VERSION NUMBER *
// **********************

#define kMapFunctionVersion @"0.5"
