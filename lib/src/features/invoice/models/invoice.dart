class Invoice {
  Invoice({
    required this.id,
    required this.title,
  });

  final int id;
  String title;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      title: map['title'],
    );
  }
}
