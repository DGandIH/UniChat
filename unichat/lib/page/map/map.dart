import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:unichat/page/map/location.dart';
import 'package:unichat/page/profile/studentProfile.dart';
import 'package:unichat/user/student.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  UserLocation userLocation = UserLocation();
  late String userId;
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
    initializeLocation();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<void> initializeLocation() async {
    await getCurrentLocationAndSave();
    await displayNearbyUsers();
  }

  Future<void> getCurrentLocationAndSave() async {

    try {
      final position = await geo.Geolocator.getCurrentPosition();
      // final locationData = LocationData.fromMap({
      //   'latitude': position.latitude,
      //   'longitude': position.longitude
      // });
      userLocation.saveUserLocation(position.latitude, position.longitude, userId);
      // userLocation.saveUserLocation(36.10221, 129.38808, "GsH3lb2LhWSXzojEGTvF7EA3XCB2");
      // userLocation.saveUserLocation(36.101929, 129.391449, "LeeDabin");
      // userLocation.saveUserLocation(35.986752, 129.421242, "SoByungchan");

      final marker = Marker(
        markerId: MarkerId("currentLocation"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: '내 위치'),
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

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    var userDocument = await FirebaseFirestore.instance.collection('user').doc(uid).get();
    return userDocument.data() ?? {};
  }

  Future<void> displayNearbyUsers() async {
    final currentPosition = await geo.Geolocator.getCurrentPosition();

    final userLocationsStream = userLocation.getNearbyUsers(
        currentPosition.latitude, currentPosition.longitude, 5);

    userLocationsStream.listen((List<DocumentSnapshot> documentList) async {
      var newMarkers = <Marker>[];
      for (var document in documentList) {
        final data = document.data() as Map<String, dynamic>?;
        print(data);
        if (data != null) {
          final geoPoint = data['position']['geopoint'];
          if (geoPoint != null) {
            print(document.id);
            Map<String, dynamic> userInfo = await getUserInfo(document.id);
            Student student = Student.fromMap(userInfo);

            final marker = Marker(
                markerId: MarkerId(document.id),
                position: LatLng(geoPoint.latitude, geoPoint.longitude),
                infoWindow: InfoWindow(
                  title: userInfo['name'],
                  snippet: 'Email: ${userInfo['email']}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeroControllerScope(
                        controller: HeroController(),
                        child: StudentProfile(student: student),
                      ),
                    ),
                  );
                }
            );
            newMarkers.add(marker);
          }
        }
      }
      setState(() {
        _markers.clear();
        _markers.addAll(newMarkers);
      });
    });
  }



  // void addUserMarkers() async {
  //   UserLocation userLocation = UserLocation();
  //   final currentPosition = await getUserCurrentLocation();
  //   var markers = await userLocation.loadUserLocationMarkers();
  //   setState(() {
  //     _markers.addAll(
  //       markers.where((marker) {
  //         final markerPosition = LatLng(marker.position.latitude, marker.position.longitude);
  //         final distanceInMeters = geo.Geolocator.distanceBetween(
  //             currentPosition.latitude,
  //             currentPosition.longitude,
  //             markerPosition.latitude,
  //             markerPosition.longitude
  //         );
  //         return distanceInMeters <= 5000;
  //       }).toList(),
  //     );
  //   });
  // }


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
            onTap: (LatLng position) {

            },
            zoomControlsEnabled: true,
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'uniqueTag1',
            onPressed: _zoomIn,
            tooltip: 'Zoom In',
            child: Icon(Icons.zoom_in),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'uniqueTag2',
            onPressed: _zoomOut,
            tooltip: 'Zoom Out',
            child: Icon(Icons.zoom_out),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'uniqueTag3',
            onPressed: () async {
              getUserCurrentLocation().then((value) async {
                // print(value.latitude.toString() +" "+value.longitude.toString());
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
