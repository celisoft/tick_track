import 'package:flutter/material.dart';
import 'ActivityRecord.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tick Track',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TickTrackHomePage(title: 'Tick Track'),
    );
  }
}

class TickTrackHomePage extends StatefulWidget {
  TickTrackHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TickTrackHomePageState createState() => _TickTrackHomePageState();
}

class _TickTrackHomePageState extends State<TickTrackHomePage> {
  ActivityRecord _activityRecord = new ActivityRecord();

  void _updateActivity() {
    setState(() {
      _activityRecord.addNewGpsPoint();
    });
  }

  void _startActivity() {
    setState(() {
      _activityRecord.startTime = new DateTime.now();
      _activityRecord.status = ActivityStatus.in_progress;
    });
  }

  void _pauseActivity() {
    setState(() {
      _activityRecord.status = ActivityStatus.paused;
    });
  }

  void _stopActivity() {
    setState(() {
      _activityRecord.status = ActivityStatus.stopped;
    });
  }

  void _saveActivity() {
    setState(() {
      _activityRecord.saveToGpx();
    });
  }

  FloatingActionButton _switchRecordStopIcon() {
    if (_activityRecord.status == ActivityStatus.in_progress ||
        _activityRecord.status == ActivityStatus.paused) {
      return FloatingActionButton(
          onPressed: _stopActivity,
          tooltip: 'Stop activity',
          child: Icon(Icons.stop));
    } else {
      return FloatingActionButton(
          onPressed: _saveActivity,
          tooltip: 'Save activity as GPX file',
          child: Icon(Icons.save));
    }
  }

  FloatingActionButton _switchPlayPauseIcon() {
    if (_activityRecord.status == ActivityStatus.in_progress) {
      return FloatingActionButton(
        onPressed: _pauseActivity,
        tooltip: 'Pause activity',
        child: Icon(Icons.pause),
      );
    }else{
      return FloatingActionButton(
        onPressed: _startActivity,
        tooltip: 'Start a new activity',
        child: Icon(Icons.play_arrow),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_activityRecord',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
            child: Row(
          children: [
            FloatingActionButton(
              onPressed: _updateActivity,
              tooltip: 'Add GPS point',
              child: Icon(Icons.add),
            ),
            _switchPlayPauseIcon(),
            _switchRecordStopIcon(),
          ],
        )));
  }
}
