import 'dart:async';

import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';

const kGoogleApiKey = "{your API key}";

main() {
  runApp(MyApp());
}

final customTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  accentColor: Colors.redAccent,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.00)),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 12.50,
      horizontal: 10.00,
    ),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "My App",
        theme: customTheme,
        home: Home(),
      );
}

class Home extends StatelessWidget {
// to get places detail (lat/lng)
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      print("${p.description} - $lat/$lng");
    }
  }

  @override
  Widget build(BuildContext context) {
    Prediction p;
    void _handlePressButton() async {
      p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [
          new Component(Component.country, "NG"),
        ],
      );
      displayPrediction(p);
    }

    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: _handlePressButton,
          child: Text("Search places"),
        ),
      ),
    );
  }
}
