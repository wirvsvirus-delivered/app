import 'dart:wasm';

import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = new Location();

  Future<bool> setup() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.DENIED) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.GRANTED) {
        return false;
      }
    }

    return true;
  }

  Future<LocationData> getLocation(LocationAccuracy accuracy) {
    location.changeSettings(accuracy: accuracy);
    return location.getLocation();
  }

  Future<int> getZipByLocation() async {
    LocationData locationData = await getLocation(LocationAccuracy.LOW);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        new Coordinates(locationData.latitude, locationData.longitude));
    Address address = addresses.first;
    return int.parse(address.postalCode);
  }
}
