import 'package:geolocator/geolocator.dart';

///
/// Status represents the status of an activity :
///
enum ActivityStatus { 
   none, // activity not started, the default status before the activity starts
   in_progress, // work in progress, the user is in activity
   stopped, // activity is now finished
   paused // activity paused, the user is taking a break
}

///
/// ActivityRecord represents an activity (running, cycling, swimming ...)
///
class ActivityRecord {
  ActivityRecord({
    this.name,
    this.status,
    this.points
  });

  String name;
  ActivityStatus status;

  // Position is provided by geolocator library
  List<Position> points;

  @override
  String toString() {
    return "Activity " + name + ": " + points.length.toString() + ' GPS points.' ;
  }
}