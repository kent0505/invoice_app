class Invoice {
  Invoice({
    required this.id,
    required this.date,
    required this.index,
    required this.businessID,
    required this.clientID,
  });

  final int id;
  String date;
  int index;
  int businessID;
  int clientID;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'index': index,
      'businessID': businessID,
      'clientID': clientID,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      date: map['date'],
      index: map['index'],
      businessID: map['businessID'],
      clientID: map['clientID'],
    );
  }
}
