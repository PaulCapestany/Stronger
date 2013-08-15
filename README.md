## TODO

### Top Priority

### Upcoming
 * create users for app <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L12">`AppConstants.h:12`</a>
 * add file for passwords/etc to .gitignore <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L16">`AppConstants.h:16`</a>
 * build database of exercises/machines <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L20">`AppConstants.h:20`</a>
 * reimplement constants once I've sorted out auth stuff <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L28">`AppConstants.h:28`</a>
 * need to create login screen <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppDelegate.m#L68">`AppDelegate.m:68`</a>
 * create "sortable" view for Workouts (substitute "a_creation_date" with sort numbers from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppDelegate.m#L160">`AppDelegate.m:160`</a>
 * create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppDelegate.m#L171">`AppDelegate.m:171`</a>
 * find out why the activityIndicator is always active... <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppDelegate.m#L225">`AppDelegate.m:225`</a>
 * should probably relate to pre-fab exercises <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/M_Exercise.h#L37">`M_Exercise.h:37`</a>
 * update all other CBLModels with similar edit logic <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/M_Settings.m#L42">`M_Settings.m:42`</a>
 * add in ability to edit `selectedExercise` <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Exercise.m#L133">`V_Exercise.m:133`</a>
 * properly implement `numberOfRowsInSection` <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Set.m#L207">`V_Set.m:207`</a>
 * add in ability to edit `selectedWorkout` <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Workout.m#L135">`V_Workout.m:135`</a>
 * change this test <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/vendor/Logging/LoggerClient.m#L482">`vendor/Logging/LoggerClient.m:482`</a>
 * Make introspection for primitive types work. <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/vendor/PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m#L195">`vendor/PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m:195`</a>
 * maybe not copy this for performance <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L719">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:719`</a>
 * Handle invalid opcode <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L880">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:880`</a>
 * Optimize the crap out of this.  Don't really have to copy all the data each time <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L1238">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:1238`</a>
 * could probably optimize this with SIMD <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L1358">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:1358`</a>

### Open questions
 * find out if I need to change how I'm doing the IDs for each doc <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L14">`AppConstants.h:14`</a>
 * look into `UICollectionView` <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L18">`AppConstants.h:18`</a>
 * explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`? <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppConstants.h#L22">`AppConstants.h:22`</a>
 * change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)? <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppDelegate.m#L153">`AppDelegate.m:153`</a>
 * CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/AppDelegate.m#L172">`AppDelegate.m:172`</a>
 * I think these need to actually be `M_Workout` models? <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/M_Settings.h#L28">`M_Settings.h:28`</a>
 * not sure why delegate methods aren't being called... <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Set.m#L41">`V_Set.m:41`</a>
 * different way to deal with errors now? <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Workout.m#L141">`V_Workout.m:141`</a>
 * need to make `moveRowAtIndexPath` actually get called! <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Workout.m#L190">`V_Workout.m:190`</a>
 * *save* method seems to have changed (no longer *RestOperation*-based)? <a href="https://github.com/PaulCapestany/Stronger/blob/ponydebugger/Stronger/V_Workout.m#L232">`V_Workout.m:232`</a>


_Build version 0.0.0_

<!---->
