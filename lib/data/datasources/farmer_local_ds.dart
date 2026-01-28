import 'package:farmconnect/data/models/farmer_models.dart';
import 'package:hive/hive.dart';


class FarmerLocalDS {
  final box = Hive.box('farmers');

  void save(FarmerModel farmer) {
    box.add(farmer.toMap());
  }

  List<FarmerModel> getAll() {
    return box.values
        .map((e) => FarmerModel.fromMap(Map.from(e)))
        .toList();
  }
}
