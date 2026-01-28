import 'package:farmconnect/core/theme/app_theme.dart';
import 'package:farmconnect/core/utils/validators.dart';
import 'package:farmconnect/domain/entities/farmer.dart';
import 'package:farmconnect/presentation/bloc/farmer_bloc.dart';
import 'package:farmconnect/presentation/bloc/farmer_event.dart';
import 'package:farmconnect/presentation/bloc/farmer_state.dart';
import 'package:farmconnect/presentation/widgets/input_field.dart';
import 'package:farmconnect/presentation/widgets/stepper_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class RegisterView extends StatefulWidget {
  final VoidCallback onRegistrationSuccess;

  const RegisterView({super.key, required this.onRegistrationSuccess});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Step 1: Personal Info
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nameFocus = FocusNode();
  final _mobileFocus = FocusNode();

  // Step 2: Location
  final _pinController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _talukaController = TextEditingController();
  final _villageController = TextEditingController();

  final _pinFocus = FocusNode();
  final _stateFocus = FocusNode();
  final _districtFocus = FocusNode();
  final _talukaFocus = FocusNode();
  final _villageFocus = FocusNode();

  // Step 3: Farm Details
  final _cropController = TextEditingController();
  final _acreageController = TextEditingController();
  final _cropFocus = FocusNode();
  final _acreageFocus = FocusNode();

  DateTime? _harvestDate;

  // Distance Calculation
  double? _distanceKm;
  bool _isCalculatingDistance = false;

  // Market Location: Kalmeshwar APMC Market, Nagpur
  static const double _marketLat = 21.2400895;
  static const double _marketLng = 78.9009647;

  bool _isLoadingPin = false;
  bool _enableAddressFields = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _pinController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _talukaController.dispose();
    _villageController.dispose();
    _cropController.dispose();
    _acreageController.dispose();

    _nameFocus.dispose();
    _mobileFocus.dispose();
    _pinFocus.dispose();
    _stateFocus.dispose();
    _districtFocus.dispose();
    _talukaFocus.dispose();
    _villageFocus.dispose();
    _cropFocus.dispose();
    _acreageFocus.dispose();

    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      if (_formKey.currentState!.validate()) {
        if (_currentStep == 2) {
          if (_harvestDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a harvesting date')),
            );
            return;
          }
          if (_distanceKm == null) {
            // Optional: Block if distance is mandatory, or just warn
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Please capture your location to calculate distance',
                ),
              ),
            );
            return;
          }
        }
        setState(() {
          _currentStep++;
        });
      }
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submit() {
    final farmer = Farmer(
      name: _nameController.text,
      mobile: _mobileController.text,
      state: _stateController.text,
      district: _districtController.text,
      taluka: _talukaController.text,
      village: _villageController.text,
      crop: _cropController.text,
      acreage: double.tryParse(_acreageController.text) ?? 0.0,
      harvestDate: _harvestDate ?? DateTime.now(),
      distanceKm: _distanceKm ?? 0.0,
    );

    context.read<FarmerBloc>().add(AddFarmer(farmer));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registration Successful'),
        content: const Text('Farmer has been registered successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Reset form
              setState(() {
                _currentStep = 0;
                _nameController.clear();
                _mobileController.clear();
                _pinController.clear();
                _stateController.clear();
                _districtController.clear();
                _talukaController.clear();
                _villageController.clear();
                _cropController.clear();
                _acreageController.clear();
                _harvestDate = null;
                _distanceKm = null;
                _enableAddressFields = false;
              });

              // Helper to switch view
              widget.onRegistrationSuccess();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _harvestDate = date;
      });
    }
  }

  Future<void> _captureLocation() async {
    setState(() {
      _isCalculatingDistance = true;
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      Position position = await Geolocator.getCurrentPosition();

      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _marketLat,
        _marketLng,
      );

      setState(() {
        _distanceKm = double.parse(
          (distanceInMeters / 1000).toStringAsFixed(2),
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location captured! Distance: $_distanceKm km'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      setState(() {
        _isCalculatingDistance = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FarmerBloc, FarmerState>(
      listener: (context, state) {
        if (state is PinLoading) {
          setState(() {
            _isLoadingPin = true;
            _enableAddressFields = false;
          });
        } else if (state is PinLoaded) {
          setState(() {
            _isLoadingPin = false;
            _enableAddressFields = false;
          });
          _stateController.text = state.state;
          _districtController.text = state.district;
          _talukaController.text = state.taluka;
          FocusScope.of(context).requestFocus(_villageFocus);
        } else if (state is PinError) {
          setState(() {
            _isLoadingPin = false;
            _enableAddressFields = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not fetch details. Please enter manually.'),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Farmer Registration',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Align(
            alignment: Alignment.center,
            child: Text('Basic details', style: TextStyle(color: Colors.grey)),
          ),

          RegistrationStepper(
            currentStep: _currentStep,
            steps: const [
              'Personal Info',
              'Location',
              'Farm Details',
              'Confirm',
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(children: [_buildStepContent()]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryGreen),
                        foregroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Back'),
                    ),
                  )
                else
                  const Spacer(),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _currentStep == 3 ? 'Complete Registration' : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: 'Farmer Name',
              hintText: 'Enter full name',
              prefixIcon: Icons.person_outline,
              controller: _nameController,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_mobileFocus),
              isRequired: true,
              validator: Validators.validateName,
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Mobile Number',
              hintText: 'Enter 10-digit mobile number',
              prefixIcon: Icons.phone_outlined,
              controller: _mobileController,
              focusNode: _mobileFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _nextStep(),
              keyboardType: TextInputType.phone,
              isRequired: true,
              validator: Validators.validateMobileNumber,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              onChanged: (value) {
                if (value.length == 10) {
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  label: 'Pin Code',
                  hintText: 'Enter 6-digit pin code',
                  prefixIcon: Icons.location_on_outlined,
                  controller: _pinController,
                  focusNode: _pinFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_stateFocus),
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  validator: Validators.validatePinCode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (value) {
                    if (value.length == 6) {
                      FocusScope.of(
                        context,
                      ).unfocus(); // Unfocus to show loading without keyboard
                      context.read<FarmerBloc>().add(FetchPinDetails(value));
                    }
                  },
                ),
                if (_isLoadingPin)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: 'State',
                    hintText: 'State',
                    controller: _stateController,
                    focusNode: _stateFocus,
                    readOnly: !_enableAddressFields,
                    isRequired: true,
                    validator: (v) => Validators.validateRequired(v, 'State'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InputField(
                    label: 'District',
                    hintText: 'District',
                    controller: _districtController,
                    focusNode: _districtFocus,
                    readOnly: !_enableAddressFields,
                    isRequired: true,
                    validator: (v) =>
                        Validators.validateRequired(v, 'District'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InputField(
                    label: 'Taluka',
                    hintText: 'Taluka',
                    controller: _talukaController,
                    focusNode: _talukaFocus,
                    readOnly: !_enableAddressFields,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InputField(
                    label: 'Village',
                    hintText: 'Enter village name',
                    controller: _villageController,
                    focusNode: _villageFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _nextStep(),
                    isRequired: true,
                    validator: (v) => Validators.validateRequired(v, 'Village'),
                  ),
                ),
              ],
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              label: 'Crop Name',
              hintText: 'e.g., Wheat, Rice, Cotton',
              prefixIcon: Icons.grass_outlined,
              controller: _cropController,
              focusNode: _cropFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_acreageFocus),
              isRequired: true,
              validator: (v) => Validators.validateRequired(v, 'Crop Name'),
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Acreage (in acres)',
              hintText: 'e.g., 5.5',
              prefixIcon: Icons.landscape_outlined,
              controller: _acreageController,
              focusNode: _acreageFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).unfocus();
                _selectDate();
              },
              keyboardType: TextInputType.number,
              isRequired: true,
              validator: Validators.validateAcreage,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RichText(
                text: const TextSpan(
                  text: 'Harvesting Date',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _harvestDate == null
                          ? 'Select harvesting date'
                          : DateFormat('MMMM d, y').format(_harvestDate!),
                      style: TextStyle(
                        color: _harvestDate == null
                            ? Colors.grey[600]
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Your Location',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            InkWell(
              onTap: _isCalculatingDistance ? null : _captureLocation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryGreen),
                  borderRadius: BorderRadius.circular(8),
                  color: _distanceKm != null
                      ? Colors.green.shade50
                      : Colors.white,
                ),
                child: _isCalculatingDistance
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _distanceKm != null
                                ? Icons.check_circle
                                : Icons.near_me,
                            color: AppTheme.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _distanceKm != null
                                ? 'Distance Captured: $_distanceKm km'
                                : 'Capture my location',
                            style: const TextStyle(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (_distanceKm != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Distance to Market: $_distanceKm km',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        );
      case 3:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Review Your Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReviewItem('Name', _nameController.text),
                      ),
                      Expanded(
                        child: _buildReviewItem(
                          'Mobile',
                          _mobileController.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReviewItem(
                          'Location',
                          '${_villageController.text}, ${_talukaController.text}\n${_districtController.text}, ${_stateController.text} - ${_pinController.text}',
                        ),
                      ),
                      Expanded(
                        child: _buildReviewItem('Crop', _cropController.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildReviewItem(
                          'Acreage',
                          '${_acreageController.text} acres',
                        ),
                      ),
                      Expanded(
                        child: _buildReviewItem(
                          'Harvest Date',
                          _harvestDate != null
                              ? DateFormat('MMMM d, y').format(_harvestDate!)
                              : '-',
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    'Distance to Kalmeshwar APMC Market: ${_distanceKm ?? 0.0} km',
                    style: const TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _buildReviewItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
