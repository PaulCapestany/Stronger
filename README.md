## TODO

### Top Priority

### Upcoming
 * create users for app <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L11">`AppConstants.h:11`</a>
 * add file for passwords/etc to .gitignore <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L15">`AppConstants.h:15`</a>
 * build database of exercises/machines <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L19">`AppConstants.h:19`</a>
 * reimplement constants once I've sorted out auth stuff <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L27">`AppConstants.h:27`</a>
 * create "sortable" view for Workouts (substitute "a_creation_date" with sort numbers from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppDelegate.m#L159">`AppDelegate.m:159`</a>
 * create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppDelegate.m#L170">`AppDelegate.m:170`</a>
 * make date grouping logic smarter with `compare` method <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppDelegate.m#L181">`AppDelegate.m:181`</a>
 * should probably relate to pre-fab exercises <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/M_Exercise.h#L37">`M_Exercise.h:37`</a>
 * update all other CBLModels with similar edit logic <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/M_Settings.m#L42">`M_Settings.m:42`</a>
 * add in ability to edit `selectedExercise` <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Exercise.m#L129">`V_Exercise.m:129`</a>
 * properly implement `numberOfRowsInSection` <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Set.m#L213">`V_Set.m:213`</a>
 * add in ability to edit `selectedWorkout` <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Workout.m#L153">`V_Workout.m:153`</a>
 * potentially unnecessary because I can just use willUpdateFromQuery <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Workout.m#L206">`V_Workout.m:206`</a>

### Open questions
 * find out if I need to change how I'm doing the IDs for each doc <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L13">`AppConstants.h:13`</a>
 * look into `UICollectionView` <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L17">`AppConstants.h:17`</a>
 * explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`? <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppConstants.h#L21">`AppConstants.h:21`</a>
 * will this work? <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppDelegate.m#L74">`AppDelegate.m:74`</a>
 * change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)? <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppDelegate.m#L152">`AppDelegate.m:152`</a>
 * CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/AppDelegate.m#L171">`AppDelegate.m:171`</a>
 * I think these need to actually be `M_Workout` models? <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/M_Settings.h#L28">`M_Settings.h:28`</a>
 * this may have been causing crash with PonyDebugger... <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Exercise.m#L212">`V_Exercise.m:212`</a>
 * this may have been causing crash with PonyDebugger... <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Set.m#L401">`V_Set.m:401`</a>
 * different way to deal with errors now? <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Workout.m#L159">`V_Workout.m:159`</a>
 * need to make `moveRowAtIndexPath` actually get called! <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Workout.m#L192">`V_Workout.m:192`</a>
 * *save* method seems to have changed (no longer *RestOperation*-based)? <a href="https://github.com/PaulCapestany/Stronger/blob/temp/Stronger/V_Workout.m#L225">`V_Workout.m:225`</a>


_Build version 0.0.0_

<!---->
