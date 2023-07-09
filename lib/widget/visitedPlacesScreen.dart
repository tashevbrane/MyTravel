import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/visitedPlace.dart';

class VisitedPlaceScreen extends StatefulWidget {
  final CameraController cameraController;
  final String placeName;
  final List<String> imageList;

  VisitedPlaceScreen({
    required this.placeName,
    required this.cameraController,
    required this.imageList,
  });

  @override
  _VisitedPlaceScreenState createState() => _VisitedPlaceScreenState();
}

class _VisitedPlaceScreenState extends State<VisitedPlaceScreen> {
  List<String> imageList = [];
  late String location;
  late LatLng currentPosition;

  @override
  void initState() {
    super.initState();
    imageList = widget.imageList;
    location = '';
    currentPosition = LatLng(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visited Place'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.placeName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Location: $location',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _getCurrentLocation();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text("Get Location"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Images:',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Wrap(
              spacing: 10,
              children: imageList.asMap().entries.map((entry) {
                final int index = entry.key;
                final String imageUrl = entry.value;
                return Container(
                  width: 150,
                  height: 150,
                  child: Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.orange),
                          onPressed: () {
                            _deleteImage(index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  _navigateToCameraScreen();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveVisitedPlace();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      location = '(${position.latitude}, ${position.longitude})';
    });
  }

  void _deleteImage(int index) {
    setState(() {
      imageList.removeAt(index);
    });
  }

  void _navigateToCameraScreen() async {
    final imagePath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CameraScreen(cameraController: widget.cameraController),
      ),
    );

    if (imagePath != null) {
      setState(() {
        imageList.add(imagePath);
      });
    }
  }

  void _saveVisitedPlace() {
    // Validate if required fields are filled
    if (location.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please enter the location.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Save the visited place and pass the data back to the previous screen
      final visitedPlace = VisitedPlace(
        placeName: widget.placeName,
        location: location,
        imageList: imageList,
      );
      Navigator.of(context).pop(visitedPlace);
    }
  }
}

class CameraScreen extends StatelessWidget {
  final CameraController cameraController;

  const CameraScreen({required this.cameraController});

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Colors.orange,
      ),
      body: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _captureImage(context);
        },
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.orange,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _captureImage(BuildContext context) async {
    final XFile? image = await cameraController.takePicture();
    if (image != null) {
      final String imagePath = image.path;
      Navigator.pop(context, imagePath);
    }
  }
}
