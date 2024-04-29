class Position {
  final String name;
  final dynamic long;
  final dynamic lat;

  Position({
    required this.name,
    required this.long,
    required this.lat,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        name: json["name"],
        long: json["long"],
        lat: json["lat"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "long": long,
        "lat": lat,
      };
}
