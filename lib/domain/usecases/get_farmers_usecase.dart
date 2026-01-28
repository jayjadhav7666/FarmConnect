import 'package:farmconnect/domain/entities/farmer.dart';
import 'package:farmconnect/domain/repositories/farmer_repository.dart';

class GetFarmersUseCase {
  final FarmerRepository repository;

  GetFarmersUseCase(this.repository);

  List<Farmer> execute() {
    return repository.getFarmers();
  }
}
