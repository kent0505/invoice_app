import '../../../core/constants.dart';

class Invoice {
  Invoice({
    required this.id,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.businessID,
    required this.clientID,
    this.paymentDate = 0,
    this.paymentMethod = '',
  });

  final int id;
  final int number;
  final int date;
  final int dueDate;
  final int businessID;
  final int clientID;
  final int paymentDate;
  final String paymentMethod;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'date': date,
      'dueDate': dueDate,
      'businessID': businessID,
      'clientID': clientID,
      'paymentDate': paymentDate,
      'paymentMethod': paymentMethod,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      number: map['number'],
      date: map['date'],
      dueDate: map['dueDate'],
      businessID: map['businessID'],
      clientID: map['clientID'],
      paymentDate: map['paymentDate'],
      paymentMethod: map['paymentMethod'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.invoices} (
      id INTEGER,
      number INTEGER,
      date INTEGER,
      dueDate INTEGER,
      businessID INTEGER,
      clientID INTEGER,
      paymentDate INTEGER,
      paymentMethod TEXT
    )
    ''';
}
