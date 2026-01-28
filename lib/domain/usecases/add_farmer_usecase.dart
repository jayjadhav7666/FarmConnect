import 'package:farmconnect/domain/entities/farmer.dart';
import 'package:farmconnect/domain/repositories/farmer_repository.dart';

class AddFarmerUseCase {
  final FarmerRepository repository;

  AddFarmerUseCase(this.repository);

  Future<void> execute(Farmer farmer) {
    return repository.addFarmer(farmer);
  }
}
