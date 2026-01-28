import 'package:farmconnect/data/repositories/farmer_repository_impl.dart';
import 'package:farmconnect/domain/repositories/farmer_repository.dart';
import 'package:farmconnect/domain/usecases/add_farmer_usecase.dart';
import 'package:farmconnect/domain/usecases/get_farmers_usecase.dart';
import 'package:farmconnect/domain/usecases/get_pincode_details_usecase.dart';
import 'package:farmconnect/presentation/bloc/farmer_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initServiceLocator() async {
  // Repositories
  serviceLocator.registerLazySingleton<FarmerRepository>(() => FarmerRepositoryImpl());

  // Use Cases
  serviceLocator.registerLazySingleton(() => AddFarmerUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetFarmersUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetPinCodeDetailsUseCase(serviceLocator()));

  // Blocs
  serviceLocator.registerFactory<FarmerBloc>(() => FarmerBloc(
        addFarmerUseCase: serviceLocator(),
        getFarmersUseCase: serviceLocator(),
        getPinCodeDetailsUseCase: serviceLocator(),
      ));
}
