class Country {
  final String id;
  final String name;
  final String flag;
  List<String> cities;
  Country(
      {required this.name,
      required this.flag,
      required this.cities,
      required this.id});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['iso2'] ?? "",
      name: json['country'] ?? '',
      flag: json['flag'] ?? '',
      cities: List<String>.from(json["cities"].map((x) => x)),
    );
  }
  factory Country.fromJsonFlag(Map<String, dynamic> json) {
    return Country(
      id: json['iso2'] ?? "",
      name: json['name'] ?? '',
      flag: json['flag'] ?? '',
      cities: [],
    );
  }
}
