import 'package:flutter/material.dart';
import 'package:mytravel/model/trip.dart';
import 'package:camera/camera.dart';
import 'package:mytravel/widget/visitedPlacesScreen.dart';

import '../model/visitedPlace.dart';

class TripDetailsPage extends StatefulWidget {
  final CameraController cameraController;
  final Trip trip;

  TripDetailsPage({required this.trip, required this.cameraController});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  List<String> imageList = [];

  String updatedDescription = '';

  List<VisitedPlace> visitedPlaces = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Details'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.trip.destination,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Date: ${widget.trip.dateTime.day}/${widget.trip.dateTime.month}/${widget.trip.dateTime.year}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Description: ${widget.trip.desc}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showEditDescriptionDialog();
                  },
                  child: Container(
                    width: 30,
                    height: 20,
                    child: Icon(
                      Icons.edit,
                      size: 25,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Visited Places:',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Wrap(
            //   spacing: 10,
            //   children: visitedPlaces.asMap().entries.map((entry) {
            //     final int index = entry.key;
            //     final VisitedPlace visitedPlace = entry.value;
            //     return Container(
            //       width: 200,
            //       height: 100,
            //       child: Stack(
            //         children: [
            //           Positioned(
            //             top: 10,
            //             right: 15,
            //             child: Row(
            //               children: [
            //                 Text(
            //                   '- ${visitedPlace.placeName}\n',
            //                   style: TextStyle(
            //                     fontSize: 20,
            //                   ),
            //                 ),
            //                 IconButton(
            //                   icon: Icon(Icons.delete, color: Colors.orange),
            //                   onPressed: () {
            //                     _deleteVisitedPlace(index);
            //                   },
            //                 ),
            //                 IconButton(
            //                   icon:
            //                       Icon(Icons.visibility, color: Colors.orange),
            //                   onPressed: () {
            //                     _viewVisitedPlace(visitedPlace);
            //                   },
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   }).toList(),
            // ),
            Wrap(
              spacing: 10,
              children: visitedPlaces.asMap().entries.map((entry) {
                final int index = entry.key;
                final VisitedPlace visitedPlace = entry.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '- ${visitedPlace.placeName}\n',
                          // visitedPlace.placeName,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.orange),
                        onPressed: () {
                          _deleteVisitedPlace(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.visibility, color: Colors.orange),
                        onPressed: () {
                          _viewVisitedPlace(visitedPlace);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addVisitedPlace();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text("Add Visited Place"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addVisitedPlace() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newPlaceName = '';

        return AlertDialog(
          title: Text('Add Visited Place'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newPlaceName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Place Name',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _navigateToVisitedPlaceScreen(newPlaceName);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text("View"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToVisitedPlaceScreen(String placeName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitedPlaceScreen(
          placeName: placeName,
          cameraController: widget.cameraController,
          // location: 'location',
          imageList: [],
        ),
      ),
    );

    if (result != null && result is VisitedPlace) {
      setState(() {
        visitedPlaces.add(result);
      });
    }
  }

  void _viewVisitedPlace(VisitedPlace visitedPlace) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitedPlaceScreen(
          placeName: visitedPlace.placeName,
          cameraController: widget.cameraController,
          // location: visitedPlace.location,
          imageList: visitedPlace.imageList,
        ),
      ),
    );
  }

  void _deleteVisitedPlace(int index) {
    setState(() {
      visitedPlaces.removeAt(index);
    });
  }

  void _showEditDescriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Description'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                updatedDescription = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  widget.trip.desc = updatedDescription;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
