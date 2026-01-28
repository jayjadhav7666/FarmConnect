import 'package:farmconnect/domain/entities/farmer.dart';

class FarmerModel extends Farmer {
  FarmerModel({
    required super.name,
    required super.mobile,
    required super.state,
    required super.district,
    required super.taluka,
    required super.village,
    required super.crop,
    required super.acreage,
    required super.harvestDate,
    required super.distanceKm,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'mobile': mobile,
    'state': state,
    'district': district,
    'taluka': taluka,
    'village': village,
    'crop': crop,
    'acreage': acreage,
    'harvestDate': harvestDate.toIso8601String(),
    'distanceKm': distanceKm,
  };

  factory FarmerModel.fromMap(Map map) => FarmerModel(
    name: map['name'],
    mobile: map['mobile'],
    state: map['state'],
    district: map['district'],
    taluka: map['taluka'],
    village: map['village'],
    crop: map['crop'],
    acreage: map['acreage'],
    harvestDate: DateTime.parse(map['harvestDate']),
    distanceKm: map['distanceKm'],
  );
}
