class PlaceModel {
  String placeId;
  String description;

  PlaceModel.fromJson(Map jsonData) {
    placeId = jsonData["place_id"];
    description = jsonData["description"];
  }
}
