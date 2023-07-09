class Trip {
  final String id;
  final DateTime dateTime;
  final String destination;
  String desc;
  List<String> visitedPlaces;

  void setDescription(String newDescription) {
    desc = newDescription;
  }

  Trip({
    required this.id,
    required this.dateTime,
    required this.destination,
    required this.desc,
    List<String>? visitedPlaces,
  }) : this.visitedPlaces = visitedPlaces ?? [];
}
