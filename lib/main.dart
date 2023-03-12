import 'dart:html';

import 'package:flutter/material.dart';
import 'hourly_forecast_list.dart';
import 'server.dart';
import 'weekly_forecast_list.dart';

void main() {
  runApp(HorizonsApp());
}

class HorizonsApp extends StatelessWidget {
  HorizonsApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //debugShowCheckedModeBanner: false,
        // This is the theme of your application.
        theme: ThemeData.dark(),
        scrollBehavior: const ConstantScrollBehavior(),
        title: 'Horizons Weather',
        home: ForecastWidget());
  }
}

class ForecastWidget extends StatefulWidget {
  const ForecastWidget({Key? key}) : super(key: key);

  @override
  State<ForecastWidget> createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  int _selectedIndex = 0;
  final _tabs = [
    WeeklyForecastList.new,  /*new keyword is used to create a new instance of the WeeklyForecastList and HourlyForecastList */
    HourlyForecastList.new,
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      /* the FutureBuilder widget is used to asynchronously fetch data from a server and update the UI once the data is available. It takes a Future object as input, which represents the asynchronous operation, and a builder function that builds the widget tree based on the state of the Future.*/
      future: Server.restore(),
      builder: (context, snapshot) => Scaffold(
        body: RefreshIndicator(
          color: Colors.white,/* the RefreshIndicator widget is used to enable the user to refresh the data displayed on the screen by pulling down on the screen. It takes an onRefresh callback as input, which is called when the user pulls down on the screen. The onRefresh callback typically includes one or more asynchronous operations that fetch the latest data and update the UI.*/
          onRefresh: () async {   /* When the user pulls down on the screen to refresh the data, the onRefresh callback will be called. The await Server.refresh() statement will fetch the latest data from the server asynchronously, while the await Server.save() statement will save the data to a local database or file. */
            await Server.refresh();
            await Server.save();
            print('Refresh was called');
          },
          child: CustomScrollView(
            slivers: <Widget>[
              _buildSliverAppBar(),
              _tabs.elementAt(_selectedIndex).call()
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_week,color: Colors.orange), label: 'Weekly',),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_view_day, color: Colors.orange), label:  'Hourly',),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.yellow[800],
      expandedHeight: 220.0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        title: const Text('Esbjerg', style: TextStyle(color: Colors.white),),
        background: DecoratedBox(
          child: Image.asset(("assets/back.jpg")),
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: <Color>[Colors.orange[600]!, Colors.transparent],
            ),
          ),
          /*
          child: SizedBox(
            width: 300,
            child: Image.asset(("assets/back.jpg")),
          ),
           */
        ),
      ),
    );
  }
}

// --------------------------------------------
// Below this line are helper classes and data.

class ConstantScrollBehavior extends ScrollBehavior {
  const ConstantScrollBehavior();

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}