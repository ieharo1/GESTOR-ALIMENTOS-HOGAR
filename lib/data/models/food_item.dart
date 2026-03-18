import 'package:hive/hive.dart';

class FoodItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String? type;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final int quantity;

  @HiveField(5)
  final DateTime entryDate;

  @HiveField(6)
  final DateTime expirationDate;

  FoodItem({
    required this.id,
    required this.category,
    this.type,
    required this.name,
    required this.quantity,
    required this.entryDate,
    DateTime? expirationDate,
  }) : expirationDate = expirationDate ?? entryDate.add(const Duration(days: 7));

  FoodItem copyWith({
    String? id,
    String? category,
    String? type,
    String? name,
    int? quantity,
    DateTime? entryDate,
    DateTime? expirationDate,
  }) {
    return FoodItem(
      id: id ?? this.id,
      category: category ?? this.category,
      type: type ?? this.type,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      entryDate: entryDate ?? this.entryDate,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}

class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 0;

  @override
  FoodItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItem(
      id: fields[0] as String,
      category: fields[1] as String,
      type: fields[2] as String?,
      name: fields[3] as String,
      quantity: fields[4] as int,
      entryDate: fields[5] as DateTime,
      expirationDate: numOfFields > 6 ? fields[6] as DateTime : null,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.entryDate)
      ..writeByte(6)
      ..write(obj.expirationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
