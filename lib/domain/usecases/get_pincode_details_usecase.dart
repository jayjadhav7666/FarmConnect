import 'package:farmconnect/domain/repositories/farmer_repository.dart';

class GetPinCodeDetailsUseCase {
  final FarmerRepository repository;

  GetPinCodeDetailsUseCase(this.repository);

  Future<Map<String, String>?> execute(String pin) {
    return repository.fetchPinDetails(pin);
  }
}
