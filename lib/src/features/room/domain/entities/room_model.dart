import 'dart:convert';

import 'device_model.dart';

class RoomModel {
  int? roomId;
  List<DeviceModel> devices;
  String? name;
  String? description;
  int? brightness;
  int? occupancy;
  int? oxygenLevel;
  int? temperature;
  bool? livingRoom;

  RoomModel({
    this.roomId,
    this.devices = const [],
    this.name,
    this.description,
    this.brightness,
    this.occupancy,
    this.oxygenLevel,
    this.temperature,
    this.livingRoom,
  });

  factory RoomModel.fromRawJson(String str) => RoomModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        // roomId: json["roomId"] as int?,
        roomId: int.tryParse(json["roomId"].toString()) ?? 0,
        devices: json["devices"] == null ? [] : List<DeviceModel>.from(json["devices"]!.map((x) => DeviceModel.fromJson(x))),
        name: json["name"] as String?,
        description: json["description"],
        // brightness: json["brightness"] as int?,
        brightness: int.tryParse(json["brightness"].toString()) ?? 0,
        // occupancy: json["occupancy"] as int?,
        occupancy: int.tryParse(json["occupancy"].toString()) ?? 0,
        //  json["oxygenLevel"] type 'double' is not a subtype of type 'int?' in type cast
        oxygenLevel: int.tryParse(json["oxygenLevel"].toString()) ?? 0,
        // temperature: json["temperature"] as int?,
        temperature: int.tryParse(json["temperature"].toString()) ?? 0,
        // livingRoom: json["livingRoom"] ?? false,
        livingRoom: json["livingRoom"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "roomId": roomId,
        "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
        "name": name,
        "description": description,
        "brightness": brightness,
        "occupancy": occupancy,
        "oxygenLevel": oxygenLevel,
        "temperature": temperature,
        "livingRoom": livingRoom,
      };
}
