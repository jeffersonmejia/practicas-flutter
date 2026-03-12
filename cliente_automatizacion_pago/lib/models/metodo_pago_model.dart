class PaymentMethod {

  final String bank;
  final String accountNumber;
  final String firstName;
  final String lastName;
  final String dni;

  PaymentMethod({
    required this.bank,
    required this.accountNumber,
    required this.firstName,
    required this.lastName,
    required this.dni,
  });

  Map<String, dynamic> toJson() {
    return {
      "bank": bank,
      "accountNumber": accountNumber,
      "firstName": firstName,
      "lastName": lastName,
      "dni": dni,
    };
  }
}