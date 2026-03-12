class Payment {

  final int id;
  final String bank;
  final String payer;
  final String payee;
  final double amount;
  final String status;
  final DateTime date;

  Payment({
    required this.id,
    required this.bank,
    required this.payer,
    required this.payee,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json["id"],
      bank: json["bank"],
      payer: json["payer"],
      payee: json["payee"],
      amount: (json["amount"] as num).toDouble(),
      status: json["status"],
      date: DateTime.parse(json["date"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bank": bank,
      "payer": payer,
      "payee": payee,
      "amount": amount,
      "status": status,
      "date": date.toIso8601String(),
    };
  }
}