abstract class FarmerState {}

class FarmerInitial extends FarmerState {}

class FarmerLoaded extends FarmerState {
  final List<dynamic> farmers;

  FarmerLoaded(this.farmers);
}

class PinLoading extends FarmerState {}

class PinLoaded extends FarmerState {
  final String state;
  final String district;
  final String taluka;

  PinLoaded({
    required this.state,
    required this.district,
    required this.taluka,
  });
}

class PinError extends FarmerState {
  final String message;

  PinError(this.message);
}
