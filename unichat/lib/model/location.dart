import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';


class UserLocation {
  final double? latitude;
  final double? longitude;

  UserLocation({this.latitude, this.longitude});

  final geo = GeoFlutterFire();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveUserLocation(double? latitude, double? longitude,
      String userId) async {
    double lat = latitude ?? 0.0;
    double lng = longitude ?? 0.0;

    GeoFirePoint location = GeoFirePoint(lat, lng);
    print("location : ");
    print(location.data);
    FirebaseFirestore.instance.collection('locations').doc(userId).set({
      'position': location.data,
    }, SetOptions(merge: true));
  }

  Stream<List<DocumentSnapshot>> getNearbyUsers(double latitude,
      double longitude, double radius) {
    GeoFirePoint center = GeoFirePoint(latitude, longitude);
    var collectionReference = FirebaseFirestore.instance.collection('locations');
    GeoFlutterFire geoFlutterFire = GeoFlutterFire();

    return geoFlutterFire.collection(collectionRef: collectionReference)
        .within(
        center: center, radius: radius, field: 'position', strictMode: true);
  }

  factory UserLocation.fromJson(Map<dynamic, dynamic> json) {
    return UserLocation(
      latitude: json["latitude"] as double?,
      longitude: json["longitude"] as double?,
    );
  }
}
      