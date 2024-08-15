import 'package:clicker/common/utils/utils.dart';
import 'package:clicker/seat/model/seat_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rent_model.g.dart';

@JsonSerializable()
class RentModel {
  final int id;
  final SeatModel seat;
  @JsonKey(
      fromJson: DataUtils.dateTimeFromJson, toJson: DataUtils.dateTimeToJson)
  final DateTime startedAt;
  @JsonKey(
      fromJson: DataUtils.dateTimeFromJson, toJson: DataUtils.dateTimeToJson)
  final DateTime endedAt;
  final int userId;

  RentModel({
    required this.id,
    required this.seat,
    required this.startedAt,
    required this.endedAt,
    required this.userId,
  });

  RentModel copyWith({
    int? id,
    SeatModel? seat,
    DateTime? startedAt,
    DateTime? endedAt,
    int? userId,
  }) {
    return RentModel(
      id: id ?? this.id,
      seat: seat ?? this.seat,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      userId: userId ?? this.userId,
    );
  }

  factory RentModel.fromJson(Map<String, dynamic> json) =>
      _$RentModelFromJson(json);

  Map<String, dynamic> toJson() => _$RentModelToJson(this);

  @override
  String toString() {
    return 'RentModel(id: $id, seat: $seat, startedAt: $startedAt, endedAt: $endedAt, userId: $userId)';
  }
}
