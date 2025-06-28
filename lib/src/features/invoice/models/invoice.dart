import '../../../core/constants.dart';

class Invoice {
  Invoice({
    required this.id,
    required this.number,
    this.template = 1,
    required this.date,
    required this.dueDate,
    required this.businessID,
    required this.clientID,
    this.paymentDate = 0,
    this.paymentMethod = '',
    required this.imageSignature,
    required this.isEstimate,
  });

  final int id;
  final int number;
  int template;
  int date;
  int dueDate;
  int businessID;
  int clientID;
  int paymentDate;
  String paymentMethod;
  String imageSignature;
  String isEstimate;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'template': template,
      'date': date,
      'dueDate': dueDate,
      'businessID': businessID,
      'clientID': clientID,
      'paymentDate': paymentDate,
      'paymentMethod': paymentMethod,
      'imageSignature': imageSignature,
      'isEstimate': isEstimate,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      number: map['number'],
      template: map['template'],
      date: map['date'],
      dueDate: map['dueDate'],
      businessID: map['businessID'],
      clientID: map['clientID'],
      paymentDate: map['paymentDate'],
      paymentMethod: map['paymentMethod'],
      imageSignature: map['imageSignature'],
      isEstimate: map['isEstimate'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.invoices} (
      id INTEGER,
      number INTEGER,
      template INTEGER,
      date INTEGER,
      dueDate INTEGER,
      businessID INTEGER,
      clientID INTEGER,
      paymentDate INTEGER,
      paymentMethod TEXT,
      imageSignature TEXT,
      isEstimate TEXT
    )
    ''';

  static const drop = 'DROP TABLE IF EXISTS ${Tables.invoices};';
}
