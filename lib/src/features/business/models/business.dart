class Business {
  Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    // required this.currency,
    required this.imageLogo,
    required this.imageSignature,
  });

  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  // final String currency;
  final String imageLogo;
  final String imageSignature;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      // 'currency': currency,
      'imageLogo': imageLogo,
      'imageSignature': imageSignature,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      // currency: map['currency'] ?? '',
      imageLogo: map['imageLogo'] ?? '',
      imageSignature: map['imageSignature'] ?? '',
    );
  }
}
