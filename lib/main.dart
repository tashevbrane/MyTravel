import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytravel/model/trip.dart';
import 'package:mytravel/widget/addTrip.dart';
import 'package:mytravel/widget/tripDetails.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

late CameraController _cameraController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
  await _cameraController.initialize();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hello World',
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyTravelState();
  }
}

class _MyTravelState extends State<MyApp> {
  List<Trip> _trips = [
    Trip(
        id: "1",
        dateTime: DateTime(2023, 7, 6),
        destination: "Oslo, Norway",
        desc: "Lorem Ipsum...."),
    Trip(
        id: "2",
        dateTime: DateTime(2023, 7, 5),
        destination: "Skopje, North Macedonia",
        desc: "Lorem Ipsum....")
  ];

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: newTrip(_addNewItemToList),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addNewItemToList(Trip item) {
    setState(() {
      _trips.add(item);
      _trips.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    });
  }

  void _deleteTrip(String id) {
    setState(() {
      _trips.removeWhere((element) => element.id == id);
    });
  }

  void _openTripDetailsPage(Trip trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailsPage(
          trip: trip,
          cameraController: _cameraController,
        ),
      ),
    );
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final filteredTrips = _trips.where((trip) {
      final tripDate = DateTime(
        trip.dateTime.year,
        trip.dateTime.month,
        trip.dateTime.day,
      );
      return tripDate == _selectedDate;
    }).toList();

    filteredTrips.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: Text("MyTravel"),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            onPressed: () => _addItemFunction(context),
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: _exitApp,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            CalendarCarousel(
              onDayPressed: (DateTime date, List<dynamic> events) {
                setState(() {
                  _selectedDate = date;
                });
              },
              weekendTextStyle: TextStyle(color: Colors.red),
              thisMonthDayBorderColor: Colors.grey,
              height: 300.0,
              width: 300.0,
              selectedDateTime: _selectedDate,
            ),
            SizedBox(height: 10.0),
            filteredTrips.isEmpty
                ? Text("Нема патувања")
                : Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          child: ListTile(
                            onTap: () =>
                                _openTripDetailsPage(filteredTrips[index]),
                            title: Text(
                              filteredTrips[index].destination,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteTrip(filteredTrips[index].id),
                            ),
                          ),
                        );
                      },
                      itemCount: filteredTrips.length,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
