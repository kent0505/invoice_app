import '../../../core/constants.dart';

class Client {
  Client({
    required this.id,
    required this.billTo,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  final int id;
  final String billTo;
  final String name;
  final String phone;
  final String email;
  final String address;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'billTo': billTo,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      billTo: map['billTo'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.clients} (
      id INTEGER,
      billTo TEXT,
      name TEXT,
      phone TEXT,
      email TEXT,
      address TEXT
    )
    ''';
}
