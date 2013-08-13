## TODO

### Top Priority

### Upcoming
 * create users for app <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L11">`AppConstants.h:11`</a>
 * add file for passwords/etc to .gitignore <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L15">`AppConstants.h:15`</a>
 * build database of exercises/machines <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L19">`AppConstants.h:19`</a>
 * reimplement constants once I've sorted out auth stuff <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L27">`AppConstants.h:27`</a>
 * need to create login screen <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppDelegate.m#L45">`AppDelegate.m:45`</a>
 * create "sortable" view for Workouts (substitute "a_creation_date" with sort numbers from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppDelegate.m#L122">`AppDelegate.m:122`</a>
 * create "sortable" view for Exercises (substitute "a_creation_date" with sort order from settings doc) <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppDelegate.m#L133">`AppDelegate.m:133`</a>
 * find out why the activityIndicator is always active... <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppDelegate.m#L187">`AppDelegate.m:187`</a>
 * should probably relate to pre-fab exercises <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/M_Exercise.h#L37">`M_Exercise.h:37`</a>
 * update all other CBLModels with similar edit logic <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/M_Settings.m#L42">`M_Settings.m:42`</a>
 * add in ability to edit `selectedExercise` <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Exercise.m#L133">`V_Exercise.m:133`</a>
 * properly implement `numberOfRowsInSection` <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Set.m#L207">`V_Set.m:207`</a>
 * add in ability to edit `selectedWorkout` <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Workout.m#L135">`V_Workout.m:135`</a>
 * change this test <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/vendor/Logging/LoggerClient.m#L482">`vendor/Logging/LoggerClient.m:482`</a>

### Open questions
 * find out if I need to change how I'm doing the IDs for each doc <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L13">`AppConstants.h:13`</a>
 * look into `UICollectionView` <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L17">`AppConstants.h:17`</a>
 * explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`? <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppConstants.h#L21">`AppConstants.h:21`</a>
 * change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)? <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppDelegate.m#L115">`AppDelegate.m:115`</a>
 * CBL prevents sorting with (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath, so address it <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/AppDelegate.m#L134">`AppDelegate.m:134`</a>
 * I think these need to actually be `M_Workout` models? <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/M_Settings.h#L28">`M_Settings.h:28`</a>
 * not sure why delegate methods aren't being called... <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Set.m#L41">`V_Set.m:41`</a>
 * different way to deal with errors now? <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Workout.m#L141">`V_Workout.m:141`</a>
 * need to make `moveRowAtIndexPath` actually get called! <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Workout.m#L190">`V_Workout.m:190`</a>
 * *save* method seems to have changed (no longer *RestOperation*-based)? <a href="https://github.com/PaulCapestany/Stronger/blob/picker/Stronger/V_Workout.m#L232">`V_Workout.m:232`</a>


_Build version 0.0.0_

<!---->
