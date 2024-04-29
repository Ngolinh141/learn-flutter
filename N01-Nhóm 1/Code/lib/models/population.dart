class Population {
  final String city;
  final String country;
  final List<PopulationCount> populationCounts;

  Population({
    required this.city,
    required this.country,
    required this.populationCounts,
  });

  factory Population.fromJson(Map<String, dynamic> json) => Population(
        city: json["city"],
        country: json["country"],
        populationCounts: List<PopulationCount>.from(
            json["populationCounts"].map((x) => PopulationCount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "populationCounts":
            List<dynamic>.from(populationCounts.map((x) => x.toJson())),
      };
}

class PopulationCount {
  final String year;
  final String value;
  final String sex;
  final String reliabilty;

  PopulationCount({
    required this.year,
    required this.value,
    required this.sex,
    required this.reliabilty,
  });

  factory PopulationCount.fromJson(Map<String, dynamic> json) =>
      PopulationCount(
        year: json["year"],
        value: json["value"],
        sex: json["sex"],
        reliabilty: json["reliabilty"],
      );

  Map<String, dynamic> toJson() => {
        "year": year,
        "value": value,
        "sex": sex,
        "reliabilty": reliabilty,
      };
}
