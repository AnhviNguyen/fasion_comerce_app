// To parse this JSON data, do
//
//     final voucher = voucherFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<Voucher> voucherFromJson(String str) => List<Voucher>.from(json.decode(str).map((x) => Voucher.fromJson(x)));

String voucherToJson(List<Voucher> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Voucher {
    String id;
    int price;
    String name;
    String description;
    Detail detail;
    int conditionPrice;

    Voucher({
        required this.id,
        required this.price,
        required this.name,
        required this.description,
        required this.detail,
        required this.conditionPrice,
    });

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        price: json["price"],
        name: json["name"],
        description: json["description"],
        detail: Detail.fromJson(json["detail"]),
        conditionPrice: json["condition_price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "name": name,
        "description": description,
        "detail": detail.toJson(),
        "condition_price": conditionPrice,
    };
}

class Detail {
    List<String> terms;
    DateTime validTo;
    DateTime validFrom;
    List<RedeemLocation> redeemLocations;

    Detail({
        required this.terms,
        required this.validTo,
        required this.validFrom,
        required this.redeemLocations,
    });

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        terms: List<String>.from(json["terms"].map((x) => x)),
        validTo: DateTime.parse(json["valid_to"]),
        validFrom: DateTime.parse(json["valid_from"]),
        redeemLocations: List<RedeemLocation>.from(json["redeem_locations"].map((x) => redeemLocationValues.map[x]!)),
    );

    Map<String, dynamic> toJson() => {
        "terms": List<dynamic>.from(terms.map((x) => x)),
        "valid_to": "${validTo.year.toString().padLeft(4, '0')}-${validTo.month.toString().padLeft(2, '0')}-${validTo.day.toString().padLeft(2, '0')}",
        "valid_from": "${validFrom.year.toString().padLeft(4, '0')}-${validFrom.month.toString().padLeft(2, '0')}-${validFrom.day.toString().padLeft(2, '0')}",
        "redeem_locations": List<dynamic>.from(redeemLocations.map((x) => redeemLocationValues.reverse[x])),
    };

List<TextSpan> formattedDetails() {
    return [
      TextSpan(
        text: 'Terms: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${terms.join('\n ')}\n',
      ),
      TextSpan(
        text: 'Valid From: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${validFrom.toLocal().toIso8601String().split('T').first}\n',
      ),
      TextSpan(
        text: 'Valid To: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${validTo.toLocal().toIso8601String().split('T').first}\n',
      ),
      TextSpan(
        text: 'Redeem Locations: ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: '${redeemLocations.map((e) => redeemLocationValues.reverse[e]).join(', ')}\n',
      ),
    ];
  }
}

enum RedeemLocation {
    ONLINE_STORE,
    PHYSICAL_STORES
}

final redeemLocationValues = EnumValues({
    "Online Store": RedeemLocation.ONLINE_STORE,
    "Physical Stores": RedeemLocation.PHYSICAL_STORES
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
