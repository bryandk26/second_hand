class BuyerModel {
  String? email;
  String? fullName;
  String? phoneNumber;
  String? buyerId;
  String? address;
  String? postalCode;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  String? profileImage;
  DateTime? registeredDate;

  BuyerModel({
    this.email,
    this.fullName,
    this.phoneNumber,
    this.buyerId,
    this.address,
    this.postalCode,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.profileImage,
    this.registeredDate,
  });

  setProfileImage(String newProfileImage) {
    profileImage = newProfileImage;
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'buyerId': buyerId,
      'address': address,
      'postalCode': postalCode,
      'bankName': bankName,
      'bankAccountName': bankAccountName,
      'bankAccountNumber': bankAccountNumber,
      'profileImage': profileImage,
      'registeredDate': registeredDate,
    };
  }

  factory BuyerModel.fromMap(Map<String, dynamic> map) {
    return BuyerModel(
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      buyerId: map['buyerId'] ?? '',
      address: map['address'] ?? '',
      postalCode: map['postalCode'] ?? '',
      bankName: map['bankName'] ?? '',
      bankAccountName: map['bankAccountName'] ?? '',
      bankAccountNumber: map['bankAccountNumber'] ?? '',
      profileImage: map['profileImage'] ?? '',
      registeredDate: map['registeredDate'].toDate() ?? '',
    );
  }
}
