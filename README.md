## TODO

### Top Priority

### Upcoming
 * create users for app <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L11">`AppConstants.h:11`</a>
 * add file for passwords/etc to .gitignore <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L15">`AppConstants.h:15`</a>
 * build database of exercises/machines <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L19">`AppConstants.h:19`</a>
 * reimplement constants once I've sorted out auth stuff <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L27">`AppConstants.h:27`</a>
 * should probably relate to pre-fab exercises <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/M_Exercise.h#L25">`M_Exercise.h:25`</a>
 * create "sortable" view for Workouts (substitute "a_creation_date" with sort numbers from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/ModelStore.m#L63">`ModelStore.m:63`</a>
 * create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/ModelStore.m#L74">`ModelStore.m:74`</a>
 * make date grouping logic smarter with `compare` method <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/ModelStore.m#L85">`ModelStore.m:85`</a>
 * add in ability to edit `selectedExercise` <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/V_Exercise.m#L111">`V_Exercise.m:111`</a>
 * properly implement `numberOfRowsInSection` <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/V_Set.m#L202">`V_Set.m:202`</a>
 * add in ability to edit `selectedWorkout` <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/V_Workout.m#L129">`V_Workout.m:129`</a>
 * Make introspection for primitive types work. <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/vendor/submodules/PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m#L195">`vendor/submodules/PonyDebugger/ObjC/PonyDebugger/NSObject+PDRuntimePropertyDescriptor.m:195`</a>
 * maybe not copy this for performance <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L719">`vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:719`</a>
 * Handle invalid opcode <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L880">`vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:880`</a>
 * Optimize the crap out of this.  Don't really have to copy all the data each time <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L1238">`vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:1238`</a>
 * could probably optimize this with SIMD <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m#L1358">`vendor/submodules/PonyDebugger/ObjC/SocketRocket/SocketRocket/SRWebSocket.m:1358`</a>

### Open questions
 * find out if I need to change how I'm doing the IDs for each doc <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L13">`AppConstants.h:13`</a>
 * look into `UICollectionView` <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L17">`AppConstants.h:17`</a>
 * explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`? <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/AppConstants.h#L21">`AppConstants.h:21`</a>
 * change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)? <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/ModelStore.m#L56">`ModelStore.m:56`</a>
 * CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/ModelStore.m#L75">`ModelStore.m:75`</a>
 * this may have been causing crash with PonyDebugger... <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/V_Exercise.m#L193">`V_Exercise.m:193`</a>
 * this may have been causing crash with PonyDebugger... <a href="https://github.com/PaulCapestany/Stronger/blob/personaLogin/Stronger/V_Set.m#L389">`V_Set.m:389`</a>


_Build version 0.0.0_

<!---->
