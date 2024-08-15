import 'package:clicker/common/utils/utils.dart';
import 'package:clicker/room/model/room_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seat_model.g.dart';

@JsonSerializable()
class SeatModel {
  final int id;
  final RoomModel room;
  final int number;
  @JsonKey(
      fromJson: DataUtils.dateTimeFromJson, toJson: DataUtils.dateTimeToJson)
  final DateTime lastDetected;

  SeatModel({
    required this.id,
    required this.room,
    required this.number,
    required this.lastDetected,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) =>
      _$SeatModelFromJson(json);

  Map<String, dynamic> toJson() => _$SeatModelToJson(this);

  @override
  String toString() {
    return 'SeatModel(id: $id, room: $room, number: $number, lastDetected: $lastDetected)';
  }
}
