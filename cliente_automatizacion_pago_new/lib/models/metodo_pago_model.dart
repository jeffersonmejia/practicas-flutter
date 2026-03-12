class PaymentMethod {
  String? id; // id del documento en Firebase, opcional
  final String bank;
  final String accountNumber;
  final String firstName;
  final String lastName;
  final String dni;

  PaymentMethod({
    this.id,
    required this.bank,
    required this.accountNumber,
    required this.firstName,
    required this.lastName,
    required this.dni,
  });

  // Convierte un PaymentMethod a Map para Firebase
  Map<String, dynamic> toJson() {
    return {
      "bank": bank,
      "accountNumber": accountNumber,
      "firstName": firstName,
      "lastName": lastName,
      "dni": dni,
    };
  }

  // Crea un PaymentMethod desde Map (Firebase)
  factory PaymentMethod.fromJson(Map<String, dynamic> json, [String? id]) {
    return PaymentMethod(
      id: id,
      bank: json['bank'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      dni: json['dni'] ?? '',
    );
  }
}