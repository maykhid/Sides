// To parse this JSON data, do
//
//     final portfolio = portfolioFromJson(jsonString);

// import 'dart:js';


var jsonPortfolio = [
  {
    "symbol": "AAPL",
    "totalQuantity": 20,
    "equityValue": 2500.0,
    "pricePerShare": 125.0
  },
  {
    "symbol": "TSLA",
    "totalQuantity": 5.0,
    "equityValue": 3000.0,
    "pricePerShare": 600.0
  },
  {
    "symbol": "AMZN",
    "totalQuantity": 1.38461538,
    "equityValue": 4500.0,
    "pricePerShare": 150.0
  }
];

// String jsonPortfolio = jsonEncode(jsonString);

// List<Portfolio> portfolioFromJson(String str) =>
//     List<Portfolio>.from(json.decode(str).map((x) => Portfolio.fromJson(x)));

// String portfolioToJson(List<Portfolio> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Portfolio {
  // Portfolio({
  //   @required this.symbol,
  //   @required this.totalQuantity,
  //   @required this.equityValue,
  //   @required this.pricePerShare,
  // });

  // String symbol;
  // double totalQuantity;
  // int equityValue;
  // int pricePerShare;

  // factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
  //       symbol: json["symbol"],
  //       totalQuantity: json["totalQuantity"].toDouble(),
  //       equityValue: json["equityValue"],
  //       pricePerShare: json["pricePerShare"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "symbol": symbol,
  //       "totalQuantity": totalQuantity,
  //       "equityValue": equityValue,
  //       "pricePerShare": pricePerShare,
  //     };

  String symbol;
  double totalQuantity;
  int equityValue;
  int pricePerShare;

  Portfolio({
    this.equityValue,
    this.totalQuantity,
    this.pricePerShare,
    this.symbol,
  });

  Portfolio.fromMap(Map<dynamic, dynamic> data)
      : symbol = data["symbol"],
        totalQuantity = data["totalQuantity"],
        equityValue = data["equityValue"],
        pricePerShare = data["pricePerShare"];
}
