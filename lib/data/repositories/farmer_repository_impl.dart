import 'package:farmconnect/data/datasources/farmer_local_ds.dart';
import 'package:farmconnect/data/datasources/pincode_local_ds.dart';
import 'package:farmconnect/data/models/farmer_models.dart';
import 'package:farmconnect/domain/entities/farmer.dart';
import 'package:farmconnect/domain/repositories/farmer_repository.dart';


class FarmerRepositoryImpl implements FarmerRepository {
  final local = FarmerLocalDS();
  final pinRemote = PinCodeRemoteDS();

  @override
  Future<void> addFarmer(Farmer farmer) async {
    local.save(FarmerModel(
      name: farmer.name,
      mobile: farmer.mobile,
      state: farmer.state,
      district: farmer.district,
      taluka: farmer.taluka,
      village: farmer.village,
      crop: farmer.crop,
      acreage: farmer.acreage,
      harvestDate: farmer.harvestDate,
      distanceKm: farmer.distanceKm,
    ));
  }

  @override
  List<Farmer> getFarmers() => local.getAll();

  @override
  Future<Map<String, String>?> fetchPinDetails(String pin) {
    return pinRemote.fetch(pin);
  }
}
