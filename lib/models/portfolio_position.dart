// To parse this JSON data, do
//
//     final portfolio = portfolioFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Portfolio> portfolioFromJson(String str) => List<Portfolio>.from(json.decode(str).map((x) => Portfolio.fromJson(x)));

String portfolioToJson(List<Portfolio> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Portfolio {
    Portfolio({
        @required this.symbol,
        @required this.totalQuantity,
        @required this.equityValue,
        @required this.pricePerShare,
    });

    String symbol;
    double totalQuantity;
    int equityValue;
    int pricePerShare;

    factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
        symbol: json["symbol"],
        totalQuantity: json["totalQuantity"].toDouble(),
        equityValue: json["equityValue"],
        pricePerShare: json["pricePerShare"],
    );

    Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "totalQuantity": totalQuantity,
        "equityValue": equityValue,
        "pricePerShare": pricePerShare,
    };
}