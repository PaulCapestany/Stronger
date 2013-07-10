## TODO

### Top Priority
 * enable "Done" button properly <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Exercise.m#L128">`V_Exercise.m:128`</a>
 * enable "Done" button properly <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Set.m#L133">`V_Set.m:133`</a>
 * enable "Done" button properly <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Workout.m#L226">`V_Workout.m:226`</a>

### Upcoming
 * create users for app <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L11">`AppConstants.h:11`</a>
 * add file for passwords/etc to .gitignore <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L15">`AppConstants.h:15`</a>
 * build database of exercises/machines <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L19">`AppConstants.h:19`</a>
 * reimplement constants once I've sorted out auth stuff <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L27">`AppConstants.h:27`</a>
 * create "sortable" view for Workouts <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppDelegate.m#L62">`AppDelegate.m:62`</a>
 * create "sortable" view for Exercises <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppDelegate.m#L73">`AppDelegate.m:73`</a>
 * need to create login screen <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppDelegate.m#L100">`AppDelegate.m:100`</a>
 * should probably relate to pre-fab exercises <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/M_Exercise.h#L37">`M_Exercise.h:37`</a>
 * update all other CBLModels with similar edit logic <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/M_Settings.m#L42">`M_Settings.m:42`</a>
 * add in ability to edit `selectedExercise` <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Exercise.m#L116">`V_Exercise.m:116`</a>
 * add in ability to edit `selectedSet` <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Set.m#L122">`V_Set.m:122`</a>
 * add in ability to edit `selectedWorkout` <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Workout.m#L117">`V_Workout.m:117`</a>
 * change this test <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/vendor/Logging/LoggerClient.m#L482">`vendor/Logging/LoggerClient.m:482`</a>

### Open questions
 * find out if I need to change how I'm doing the IDs for each doc <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L13">`AppConstants.h:13`</a>
 * look into `UICollectionView` <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L17">`AppConstants.h:17`</a>
 * explore subclassing CBLLiveQuery UITableViewCell through `couchTableSource willUseCell forRow`? <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppConstants.h#L21">`AppConstants.h:21`</a>
 * change all emits to nil, use `prefetch=YES` in query instead (same as `include_docs=true`)? <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/AppDelegate.m#L55">`AppDelegate.m:55`</a>
 * I think these need to actually be `M_Workout` models? <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/M_Settings.h#L28">`M_Settings.h:28`</a>
 * different way to deal with errors now? <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Workout.m#L123">`V_Workout.m:123`</a>
 * need to make `moveRowAtIndexPath` actually get called! <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Workout.m#L172">`V_Workout.m:172`</a>
 * *save* method seems to have changed (no longer *RestOperation*-based)? <a href="https://github.com/PaulCapestany/Stronger/blob/dev/Stronger/V_Workout.m#L214">`V_Workout.m:214`</a>


_Build version 0.0.0_

<!---->
