class Budget {
  final int? id;
  final double limit;

  Budget({this.id, required this.limit});

  Map<String, dynamic> toMap() {
    return {'id': id, 'limit': limit};
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(id: map['id'], limit: map['limit']);
  }
}
