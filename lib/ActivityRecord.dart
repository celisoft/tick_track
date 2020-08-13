import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:gpx/gpx.dart';
import 'package:path_provider/path_provider.dart';

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
  // Activity name
  String name;

  // Activity status
  ActivityStatus status;

  // Activity start time
  DateTime startTime;

  // Position is provided by geolocator library
  List<Position> points;

  // Constructor
  ActivityRecord() {
    resetActivity();
  }

  // Reset the different fields
  void resetActivity() {
    this.name = "New_Activity";
    this.status = ActivityStatus.none;
    this.startTime = new DateTime.now();
    this.points = new List();
  }

  // Add a new point to the list
  Future<void> addNewGpsPoint() async {
    Position lNewPos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    points.add(lNewPos);
  }

  // Return the activity in a GPX formated String
  Future<bool> saveToGpx() async {
    // Useless to export a track without any point or just one
    if (this.points.length > 1) {
      final gpxFilepath = await getGpxExportFilepath();
      new File(gpxFilepath).writeAsString(toGpx()).then((value) {
        resetActivity();
      }).catchError((ioError) {
        return false;
      });
    }
    return true;
  }

  // Return the complete filepath where the GPX file will be written
  Future<String> getGpxExportFilepath() async {
      // Get default directory
      Directory baseAppDirectory = await getApplicationDocumentsDirectory();
      Directory appDirectory =
          await new Directory(baseAppDirectory.path + '/TickTrack')
              .create(recursive: true);

      // Build the path
      final gpxFilename = 'TickTrack_' +
          this.name +
          '_' +
          this.startTime.millisecondsSinceEpoch.toString() +
          '.gpx';
      
      return appDirectory.path + '/' + gpxFilename;
  }

  String toGpx() {
    // Create GPX object
    var gpx = Gpx();
    gpx.creator = "Tick-Track";
    gpx.metadata = new Metadata();
    gpx.metadata.time = this.startTime;
    gpx.metadata.name = this.name;

    // Add all recorded points
    this.points.forEach((pos) {
      gpx.wpts
          .add(Wpt(lat: pos.latitude, lon: pos.longitude, ele: pos.altitude));
    });

    // Generate GPX/XML string
    return GpxWriter().asString(gpx, pretty: true);
  }

  @override
  String toString() {
    return "Activity " +
        this.name +
        ": " +
        this.points.length.toString() +
        ' GPS points.';
  }
}
