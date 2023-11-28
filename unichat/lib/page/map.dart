import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:unichat/model/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  UserLocation userLocation = UserLocation();
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(36.104073990218616, 129.38877917711773),
    zoom: 14.4746,
  );

  final List<Marker> _markers = <Marker>[
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(20.42796133580664, 75.885749655962),
        infoWindow: InfoWindow(
          title: 'My Position',
        )
    ),
  ];

  @override
  void initState() {
    super.initState();
    getCurrentLocationAndSave();
    addUserMarkers();
  }

  Future<void> getCurrentLocationAndSave() async {
    try {
      final position = await geo.Geolocator.getCurrentPosition();
      final locationData = LocationData.fromMap({
        'latitude': position.latitude,
        'longitude': position.longitude
      });
      userLocation.addOrUpdateLocation(locationData, "LeeInhyeok");

      final marker = Marker(
        markerId: MarkerId("currentLocation"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: '유저 위치'),
      );

      setState(() {
        _markers.add(marker);
      });

    } catch (e) {
      print('위치 정보를 가져오는 중 에러 발생 : $e');
    }
  }

  Future<geo.Position> getUserCurrentLocation() async {
    await geo.Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await geo.Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await geo.Geolocator.getCurrentPosition();
  }

  void addUserMarkers() async {
    UserLocation userLocation = UserLocation();
    final currentPosition = await getUserCurrentLocation();
    var markers = await userLocation.loadUserLocationMarkers();
    setState(() {
      _markers.addAll(
        markers.where((marker) {
          final markerPosition = LatLng(marker.position.latitude, marker.position.longitude);
          final distanceInMeters = geo.Geolocator.distanceBetween(
              currentPosition.latitude,
              currentPosition.longitude,
              markerPosition.latitude,
              markerPosition.longitude
          );
          return distanceInMeters <= 5000;
        }).toList(),
      );
    });
  }

  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5DB075),
        title: Text(
          "지도",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(_markers),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
            zoomControlsEnabled: true,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _zoomIn,
            tooltip: 'Zoom In',
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _zoomOut,
            tooltip: 'Zoom Out',
            child: Icon(Icons.zoom_out),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                print(value.latitude.toString() +" "+value.longitude.toString());
                _markers.add(
                    Marker(
                      markerId: MarkerId("2"),
                      position: LatLng(value.latitude, value.longitude),
                      infoWindow: InfoWindow(
                        title: '내 위치',
                      ),
                    )
                );
                CameraPosition cameraPosition = new CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14,
                );
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                setState(() {});
              });
            },
            child: Icon(Icons.location_searching),
          ),
        ],
      ),
    );
  }
}
