// To parse this JSON data, do
//
//     final homeData = homeDataFromJson(jsonString);

import 'dart:convert';

HomeData homeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String homeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
  final bool? status;
  final String? message;
  final List<Map<String, dynamic>>? data;

  HomeData({
    this.status,
    this.message,
    this.data,
  });

  factory HomeData.fromJson(Map<dynamic, dynamic> json) => HomeData(
    status: json["status"],
    message: json["message"],
    data: List<Map<String, dynamic>>.from(json["data"].map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}
