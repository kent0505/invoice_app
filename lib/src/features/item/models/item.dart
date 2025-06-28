import '../../../core/constants.dart';

class Item {
  Item({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    required this.discountPrice,
    required this.tax,
    this.invoiceID = 0,
  });

  final int id;
  String title;
  String type;
  String price;
  String discountPrice;
  String tax;
  int invoiceID;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'price': price,
      'discountPrice': discountPrice,
      'tax': tax,
      'invoiceID': invoiceID,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      tax: map['tax'],
      invoiceID: map['invoiceID'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.items} (
      id INTEGER,
      title TEXT,
      type TEXT,
      price TEXT,
      discountPrice TEXT,
      tax TEXT,
      invoiceID INTEGER
    )
    ''';

  static const drop = 'DROP TABLE IF EXISTS ${Tables.items};';
}
