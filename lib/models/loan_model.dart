var jsonLoan = {
  "amount": 0.00,
  "paid": false,
  "duration": "12 months",
};

class Loan {
  var amount;
  var paid;
  var duration;

  Loan({
    this.amount,
    this.paid,
    this.duration,
  });

  Loan.fromMap(Map<dynamic, dynamic> data)
      : amount = data["amount"] ?? "",
        paid = data["paid"] ?? "",
        duration = data["duration"] ?? "";

  @override
  String toString() {
    return '{ ${this.amount}, ${this.paid}, ${this.duration},}';
  }
}
