class PaymentMethod {
  String? id;
  final String email;
  final String names;
  final String bank;
  final String accountNumber;

  PaymentMethod({
    this.id,
    required this.email,
    required this.names,
    required this.bank,
    required this.accountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "names": names,
      "bank": bank,
      "accountNumber": accountNumber,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json, [String? id]) {
    return PaymentMethod(
      id: id,
      email: json['email'] ?? '',
      names: json['names'] ?? '',
      bank: json['bank'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
    );
  }
}