import 'dart:convert';
import 'package:http/http.dart' as http;

class PinCodeRemoteDS {
  Future<Map<String, String>?> fetch(String pin) async {
    final res = await http
        .get(Uri.parse('https://api.postalpincode.in/pincode/$pin'));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data[0]['Status'] == 'Success') {
        final po = data[0]['PostOffice'][0];
        return {
          'state': po['State'],
          'district': po['District'],
          'taluka': po['Block'],
        };
      }
    }
    return null;
  }
}
