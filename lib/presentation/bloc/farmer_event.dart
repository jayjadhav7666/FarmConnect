abstract class FarmerEvent {}

class AddFarmer extends FarmerEvent {
  final dynamic farmer;
  AddFarmer(this.farmer);
}

class LoadFarmers extends FarmerEvent {}

class FetchPinDetails extends FarmerEvent {
  final String pinCode;
  FetchPinDetails(this.pinCode);
}
