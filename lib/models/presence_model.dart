class PresenceModel {
  late String date, type, time, latitude, longitude, description;

  PresenceModel(
      {required this.date,
      required this.type,
      required this.time,
      required this.latitude,
      required this.longitude,
      required this.description});

  factory PresenceModel.fromJSON(Map<String, dynamic> json) {
    return PresenceModel(
        date: json["date"],
        type: json["type"],
        time: json["time_in"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        description: json["description"]);
  }
}
