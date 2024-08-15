import 'package:clicker/rent/model/rent_model.dart';
import 'package:clicker/seat/model/seat_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'seat_info_model.g.dart';

@JsonSerializable()
class SeatInfoModel {
  final SeatModel seat;
  final RentModel? rent;

  SeatInfoModel({
    required this.seat,
    this.rent,
  });

  factory SeatInfoModel.fromJson(Map<String, dynamic> json) {
    final rentJson = json['rent'];
    return SeatInfoModel(
      seat: SeatModel.fromJson(json['seat']),
      rent: rentJson != null ? RentModel.fromJson(rentJson) : null,
    );
  }

  SeatInfoModel copyWith({RentModel? rent}) {
    return SeatInfoModel(
      seat: seat,
      rent: rent,
    );
  }

  Map<String, dynamic> toJson() => _$SeatInfoModelToJson(this);

  @override
  String toString() {
    return 'SeatInfoModel(seat: $seat, rent: $rent)';
  }
}
