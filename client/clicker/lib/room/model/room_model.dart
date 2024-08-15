import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  final int id;
  final String name;
  final int totalSeat;

  RoomModel({
    required this.id,
    required this.name,
    required this.totalSeat,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);

  @override
  String toString() {
    return 'RoomModel(id: $id, name: $name, totalSeat: $totalSeat)';
  }
}
