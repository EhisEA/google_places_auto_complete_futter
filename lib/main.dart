import 'dart:convert';

import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:places_search/place_model.dart';

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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PlaceModel> places;
// to get places detail (lat/lng)
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  void displayPrediction({
    @required String placeId,
    @required String description,
  }) async {
    if (placeId != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      print("$description - $lat/$lng");
    }
  }

  @override
  Widget build(BuildContext context) {
    void _handleSearch(query) async {
      if (query == "") return;
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      var response = await http
          .get("$url?key=$kGoogleApiKey&input=$query&components=country:ng");
      Map<String, dynamic> result = json.decode(response.body);
      if (result == null) return;
      setState(() {
        places = result["predictions"]
            .map<PlaceModel>((jsonData) => PlaceModel.fromJson(jsonData))
            .toList();
      });
    }

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              onChanged: _handleSearch,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
              child: places == null
                  ? Center(child: Text("nothing to show"))
                  : ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        PlaceModel place = places[index];
                        return InkWell(
                          onTap: () => displayPrediction(
                            placeId: place.placeId,
                            description: place.description,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text(place.description),
                            ),
                          ),
                        );
                      },
                    ))
        ],
      ),
    ));
  }
}
