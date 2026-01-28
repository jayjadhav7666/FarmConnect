import 'package:farmconnect/domain/usecases/add_farmer_usecase.dart';
import 'package:farmconnect/domain/usecases/get_farmers_usecase.dart';
import 'package:farmconnect/domain/usecases/get_pincode_details_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'farmer_event.dart';
import 'farmer_state.dart';

class FarmerBloc extends Bloc<FarmerEvent, FarmerState> {
  final AddFarmerUseCase addFarmerUseCase;
  final GetFarmersUseCase getFarmersUseCase;
  final GetPinCodeDetailsUseCase getPinCodeDetailsUseCase;

  FarmerBloc({
    required this.addFarmerUseCase,
    required this.getFarmersUseCase,
    required this.getPinCodeDetailsUseCase,
  }) : super(FarmerInitial()) {
    on<AddFarmer>((event, emit) async {
      await addFarmerUseCase.execute(event.farmer);
      emit(FarmerLoaded(getFarmersUseCase.execute()));
    });

    on<LoadFarmers>((event, emit) {
      emit(FarmerLoaded(getFarmersUseCase.execute()));
    });

    on<FetchPinDetails>((event, emit) async {
      emit(PinLoading());
      try {
        final data = await getPinCodeDetailsUseCase.execute(event.pinCode);
        if (data != null) {
          emit(PinLoaded(
            state: data['state']!,
            district: data['district']!,
            taluka: data['taluka']!,
          ));
        } else {
          emit(PinError('Invalid PIN Code'));
        }
      } catch (e) {
        emit(PinError('Failed to fetch details'));
      }
    });
  }
}
