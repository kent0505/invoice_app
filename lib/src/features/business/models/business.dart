import '../../../core/constants.dart';

class Business {
  Business({
    required this.id,
    required this.name,
    required this.businessName,
    required this.phone,
    required this.email,
    required this.address,
    required this.vat,
    required this.bank,
    required this.iban,
    required this.bic,
    required this.imageLogo,
    required this.imageSignature,
  });

  final int id;
  String name;
  String businessName;
  String phone;
  String email;
  String address;
  String vat;
  String bank;
  String iban;
  String bic;
  String imageLogo;
  String imageSignature;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'businessName': businessName,
      'phone': phone,
      'email': email,
      'address': address,
      'vat': vat,
      'bank': bank,
      'iban': iban,
      'bic': bic,
      'imageLogo': imageLogo,
      'imageSignature': imageSignature,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      name: map['name'],
      businessName: map['businessName'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      vat: map['vat'],
      bank: map['bank'],
      iban: map['iban'],
      bic: map['bic'],
      imageLogo: map['imageLogo'],
      imageSignature: map['imageSignature'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.business} (
      id INTEGER,
      name TEXT,
      businessName TEXT,
      phone TEXT,
      email TEXT,
      address TEXT,
      vat TEXT,
      bank TEXT,
      iban TEXT,
      bic TEXT,
      imageLogo TEXT,
      imageSignature TEXT
    )
    ''';

  static const drop = 'DROP TABLE IF EXISTS ${Tables.business};';
}
