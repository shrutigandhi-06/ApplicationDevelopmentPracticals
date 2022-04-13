import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'googleMapScreen.dart' as map;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String finalAddress = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choosing Current Location'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: ListTile(
            onTap: () {
              getLocation();
            },
            leading: const Icon(
              Icons.location_searching,
              color: Colors.blue,
            ),
            title: const Text(
              'Use current location',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            subtitle: Text(finalAddress == '' ? 'Address' : finalAddress),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
            ),
          ),
        ));
  }

  getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => map.GoogleMapScreen(
          lat: _locationData.latitude!,
          long: _locationData.longitude!,
          callback: (value) {
            finalAddress = value;
            setState(() {});
          },
        ),
      ),
    );
  }
}
