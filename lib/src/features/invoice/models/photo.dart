import '../../../core/constants.dart';

class Photo {
  Photo({
    required this.id,
    required this.path,
  });

  final int id;
  final String path;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      path: map['path'],
    );
  }

  static const sql = '''
    CREATE TABLE IF NOT EXISTS ${Tables.photos} (
      id INTEGER,
      path TEXT
    )
    ''';
}
