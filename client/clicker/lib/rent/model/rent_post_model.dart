import 'package:json_annotation/json_annotation.dart';

part 'rent_post_model.g.dart';

@JsonSerializable()
class RentPostModel {
  final int seat;
  final int userId;

  RentPostModel({
    required this.seat,
    required this.userId,
  });

  factory RentPostModel.fromJson(Map<String, dynamic> json) =>
      _$RentPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$RentPostModelToJson(this);

  @override
  String toString() {
    return 'RentPostModel( seat: $seat, userId: $userId)';
  }
}
