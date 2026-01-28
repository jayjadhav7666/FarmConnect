class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be exactly 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number must contain only digits';
    }
    return null;
  }

  static String? validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pin code is required';
    }
    if (value.length != 6) {
      return 'Pin code must be exactly 6 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Pin code must contain only digits';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateAcreage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Acreage is required';
    }
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'Acreage must be a valid number';
    }
    if (numValue <= 0) {
      return 'Acreage must be greater than 0';
    }
    return null;
  }
}
