import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef StringValue = void Function(String);

class GoogleMapScreen extends StatefulWidget {
  final double lat, long;
  StringValue callback;
  GoogleMapScreen(
      {Key? key, required this.lat, required this.long, required this.callback})
      : super(key: key);
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _googleMapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  String searchAddress = '';
  String finalAddress = '';

  @override
  void initState() {
    getMarkers(widget.lat, widget.long);
    getAddress(widget.lat, widget.long);
    super.initState();
  }

  getAddress(double latitude, double longitude) async {
    final coordinates = new Coordinates(latitude, longitude);
    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      finalAddress = address.first.addressLine!;
      print(finalAddress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: double.infinity,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    onTap: (tapped) async {
                      getMarkers(tapped.latitude, tapped.longitude);
                      getAddress(tapped.latitude, tapped.longitude);
                    },
                    onMapCreated: (GoogleMapController controller) {
                      setState(() {
                        _googleMapController = controller;
                      });
                    },
                    markers: Set<Marker>.of(_markers.values),
                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.lat, widget.long), zoom: 15),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.5),
                  ),
                ),
                Positioned(
                  top: 25.0,
                  left: 15.0,
                  right: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                    ),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        searchAddress = value;
                      },
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        searchAndNavigate(value);
                      },
                      decoration: InputDecoration(
                          hintText: 'Search for location',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              searchAndNavigate(searchAddress);
                            },
                            iconSize: 25.0,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address: ' + finalAddress,
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    print(finalAddress);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MakerDetails(finalAddress)));
                    widget.callback(finalAddress);
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
    );
    setState(() {
      _markers.clear();
      _markers[markerId] = marker;
    });
  }

  searchAndNavigate(String query) async {
    var address = await Geocoder.local.findAddressesFromQuery(query);
    var first = address.first;
    await _googleMapController
        .animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                  first.coordinates.latitude!, first.coordinates.longitude!),
              zoom: 18.0,
            ),
          ),
        )
        .then((value) => {
              getAddress(
                  first.coordinates.latitude!, first.coordinates.longitude!),
              getMarkers(
                  first.coordinates.latitude!, first.coordinates.longitude!)
            });
  }
}
