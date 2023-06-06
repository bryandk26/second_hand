class VendorUserModel {
  bool? approved;
  String? vendorId;
  String? businessName;
  String? address;
  String? postalCode;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  String? email;
  String? phoneNumber;
  String? _storeImage;

  VendorUserModel({
    this.approved,
    this.vendorId,
    this.businessName,
    this.address,
    this.postalCode,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.email,
    this.phoneNumber,
    String? storeImage,
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
