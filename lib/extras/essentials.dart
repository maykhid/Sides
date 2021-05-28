import 'package:trove_app/models/portfolio_position.dart';

class EssentialFunctions {
  String formatToStringComma(String value) {
    String norm = value.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return norm;
  }

  convertMapToList(List data) {
    var list = [];
    for (var i = 0; i < data.length; i++) {
      Map<dynamic, dynamic> currentElement = data[i];
      // currentElement.forEach((key, value) => list.add())
      list.add(Portfolio.fromMap(currentElement));
    }
    return list;
  }

  int sixtyPercent(String amount) {
    try{
      int newAmount = (int.parse(amount) * 0.6).toInt();
      return newAmount;
    } catch (e) {
      return null;
    } 
    // newAmount = (newAmount * 0.6).toInt();
    
  }
}
