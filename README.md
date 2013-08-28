## TODO

### Top Priority

### Upcoming
 * create users for app <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L11">`AppConstants.h:11`</a>
 * add file for passwords/etc to .gitignore <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L15">`AppConstants.h:15`</a>
 * build database of exercises/machines <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L19">`AppConstants.h:19`</a>
 * reimplement constants once I've sorted out auth stuff <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L27">`AppConstants.h:27`</a>
 * need to create login screen <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppDelegate.m#L70">`AppDelegate.m:70`</a>
 * create "sortable" view for Workouts (substitute "a_creation_date" with sort numbers from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppDelegate.m#L162">`AppDelegate.m:162`</a>
 * create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppDelegate.m#L173">`AppDelegate.m:173`</a>
 * should probably relate to pre-fab exercises <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/M_Exercise.h#L37">`M_Exercise.h:37`</a>
 * update all other CBLModels with similar edit logic <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/M_Settings.m#L42">`M_Settings.m:42`</a>
 * add in ability to edit `selectedExercise` <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Exercise.m#L129">`V_Exercise.m:129`</a>
 * properly implement `numberOfRowsInSection` <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Set.m#L213">`V_Set.m:213`</a>
 * add in ability to edit `selectedWorkout` <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Workout.m#L138">`V_Workout.m:138`</a>
 * Make introspection for primitive types work. <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/vendor/PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m#L195">`vendor/PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m:195`</a>
 * maybe not copy this for performance <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L719">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:719`</a>
 * Handle invalid opcode <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L880">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:880`</a>
 * Optimize the crap out of this.  Don't really have to copy all the data each time <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L1238">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:1238`</a>
 * could probably optimize this with SIMD <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L1358">`vendor/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:1358`</a>

### Open questions
 * find out if I need to change how I'm doing the IDs for each doc <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L13">`AppConstants.h:13`</a>
 * look into `UICollectionView` <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L17">`AppConstants.h:17`</a>
 * explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`? <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppConstants.h#L21">`AppConstants.h:21`</a>
 * change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)? <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppDelegate.m#L155">`AppDelegate.m:155`</a>
 * CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/AppDelegate.m#L174">`AppDelegate.m:174`</a>
 * I think these need to actually be `M_Workout` models? <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/M_Settings.h#L28">`M_Settings.h:28`</a>
 * this may have been causing crash with PonyDebugger... <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Exercise.m#L195">`V_Exercise.m:195`</a>
 * not sure why delegate methods aren't being called... <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Set.m#L41">`V_Set.m:41`</a>
 * this may have been causing crash with PonyDebugger... <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Set.m#L342">`V_Set.m:342`</a>
 * different way to deal with errors now? <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Workout.m#L144">`V_Workout.m:144`</a>
 * need to make `moveRowAtIndexPath` actually get called! <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Workout.m#L177">`V_Workout.m:177`</a>
 * *save* method seems to have changed (no longer *RestOperation*-based)? <a href="https://github.com/PaulCapestany/Stronger/blob/groupedTableView/Stronger/V_Workout.m#L209">`V_Workout.m:209`</a>


_Build version 0.0.0_

<!---->
