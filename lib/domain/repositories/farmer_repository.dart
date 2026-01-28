import 'package:farmconnect/domain/entities/farmer.dart';

abstract class FarmerRepository {
  Future<void> addFarmer(Farmer farmer);
  List<Farmer> getFarmers();
  Future<Map<String, String>?> fetchPinDetails(String pin);
}
