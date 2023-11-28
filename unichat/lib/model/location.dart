import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserLocation {
  final double? latitude;
  final double? longitude;

  UserLocation(
      {this.latitude, this.longitude});

  factory UserLocation.fromJson(Map<dynamic, dynamic> json) {
    return UserLocation(
      latitude: json["latitude"] as double?,
      longitude: json["longitude"] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  void updateLocationWithKey(LocationData locationData, String uniqueKey) {
    UserLocation userLocation = UserLocation(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );

    databaseReference.child('users/$uniqueKey').set(
      userLocation.toJson(),
    );
  }

  void addOrUpdateLocation(LocationData locationData, String uniqueKey) async {
    UserLocation userLocation = UserLocation(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );

    DatabaseEvent event = await databaseReference.child('users/$uniqueKey').once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      databaseReference.child('users/$uniqueKey').set(
        userLocation.toJson(),
      );
    } else {
      databaseReference.child('users/$uniqueKey').set(
        userLocation.toJson(),
      );
    }
  }

  Future<List<Marker>> loadUserLocationMarkers() async {
    List<Marker> markers = [];

    DatabaseEvent event = await databaseReference.child('users').once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> usersMap = Map<dynamic, dynamic>.from(snapshot.value as Map);
      usersMap.forEach((key, value) {
        var userLocation = UserLocation.fromJson(Map<String, dynamic>.from(value));
        var marker = Marker(
          markerId: MarkerId(key),
          position: LatLng(
            userLocation.latitude ?? 0.0,
            userLocation.longitude ?? 0.0,
          ),
          infoWindow: InfoWindow(title: 'User $key'),
        );
        markers.add(marker);
      });
    }
    return markers;
  }
}