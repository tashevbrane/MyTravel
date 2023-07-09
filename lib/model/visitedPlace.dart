class VisitedPlace {
  String placeName;
  final String location;
  final List<String> imageList;

  VisitedPlace({
    required this.placeName,
    required this.location,
    List<String>? imageList,
  }) : this.imageList = imageList ?? [];
}
