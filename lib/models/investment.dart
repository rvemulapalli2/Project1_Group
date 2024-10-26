class Investment {
  final String _id;
  final String _title;
  final double _amount;
  final DateTime _date;

  String get invId => _id;
  String get invTitle => _title;
  double get invAmount => _amount;
  DateTime get invDateTime => _date;

  // Constructor with initialization of all fields
  Investment(
    this._id,
    this._title,
    this._amount,
    this._date,
  );

  // Convenience constructor to create an Investment object from a map
  Investment.fromMap(Map<String, dynamic> map)
      : _id = map['id'].toString(),
        _title = map['title'],
        _amount = map['amount'] ?? 0.0,
        _date = DateTime.parse(map['date']);

  // Convenience method to create a map from this Investment object
  Map<String, dynamic> toMap() {
    return {
      'id': int.tryParse(_id),
      'title': _title,
      'amount': _amount,
      'date': _date.toIso8601String(),
    };
  }
}