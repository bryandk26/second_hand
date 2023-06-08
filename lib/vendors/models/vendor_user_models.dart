class VendorUserModel {
  final bool? approved;
  final String? vendorId;
  final String? businessName;
  final String? address;
  final String? postalCode;
  final String? bankName;
  final String? bankAccountName;
  final String? bankAccountNumber;
  final String? email;
  final String? phoneNumber;
  String? _storeImage;

  VendorUserModel({
    required this.approved,
    required this.vendorId,
    required this.businessName,
    required this.address,
    required this.postalCode,
    required this.bankName,
    required this.bankAccountName,
    required this.bankAccountNumber,
    required this.email,
    required this.phoneNumber,
    required String? storeImage,
  }) : _storeImage = storeImage;

  VendorUserModel.fromJson(Map<String, Object?> json)
      : this(
          approved: json['approved']! as bool,
          vendorId: json['vendorId']! as String,
          businessName: json['businessName']! as String,
          address: json['vendorAddress']! as String,
          postalCode: json['vendorPostalCode']! as String,
          bankName: json['vendorBankName']! as String,
          bankAccountName: json['vendorBankAccountName']! as String,
          bankAccountNumber: json['vendorBankAccountNumber']! as String,
          email: json['email']! as String,
          phoneNumber: json['phoneNumber']! as String,
          storeImage: json['storeImage']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'approved': approved,
      'vendorId': vendorId,
      'businessName': businessName,
      'vendorAddress': address,
      'vendorPostalCode': postalCode,
      'vendorBankName': bankName,
      'vendorBankAccountName': bankAccountName,
      'vendorBankAccountNumber': bankAccountNumber,
      'email': email,
      'phoneNumber': phoneNumber,
      'storeImage': storeImage,
    };
  }

  String? get storeImage => _storeImage;

  set storeImage(String? value) {
    _storeImage = value;
  }
}
