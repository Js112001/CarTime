class CarEntryModel {
  final int? id;
  final String carNumber;
  final DateTime checkInTime;
  final DateTime? checkOutTime;

  CarEntryModel({
    this.id,
    required this.carNumber,
    required this.checkInTime,
    this.checkOutTime,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'car_number': carNumber,
        'check_in_time': checkInTime.toString(),
        'check_out_time': checkOutTime.toString(),
      };

  factory CarEntryModel.fromMap(Map<String, dynamic> map) {
    return CarEntryModel(
      id: map['id'] as int,
      carNumber: map['car_number'] as String,
      checkInTime: DateTime.parse(map['check_in_time'].toString()),
      checkOutTime:
          map['check_out_time'] != 'null' && map['check_out_time'] is String
              ? DateTime.parse(map['check_out_time'].toString())
              : null,
    );
  }

  @override
  String toString() {
    return 'CarEntryModel(id: $id, carNumber: $carNumber, checkInTime: $checkInTime, checkOutTime: $checkOutTime)';
  }
}
