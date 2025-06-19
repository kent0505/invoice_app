import '../../../core/constants.dart';

class Business {
  Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.imageLogo,
    required this.imageSignature,
  });

  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String imageLogo;
  final String imageSignature;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'imageLogo': imageLogo,
      'imageSignature': imageSignature,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      imageLogo: map['imageLogo'],
      imageSignature: map['imageSignature'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.business} (
      id INTEGER,
      name TEXT,
      phone TEXT,
      email TEXT,
      address TEXT,
      imageLogo TEXT,
      imageSignature TEXT
    )
    ''';
}
