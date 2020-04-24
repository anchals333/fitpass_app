import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Api {

  Api();

  Future<dynamic> validateLogin(String mobile, String password) async {
    Map<String, String> headers = {
      'x-appkey': 'rcmroes1UWF2GIcBBQ5jghe6xpwoQ4vqDqoIIcBTbZEE6',
      'x-authkey': 'dgfJlO10QAoZzaiT8FXrF8bgBBQ5jghe7FNrd9t8D0u',
      'http-x-device-type': 'sfgsdhfsdhsd',
      'Content-Type': 'application/x-www-form-urlencoded',
      'device_token': 'kjjsfhsdkjfhdsfsadkfshdafsadfhsa',
      'x-device-type': 'Android',
      'x-app-version': '2.3',
      'x-device-name': 'Moto G4',
      'x-device-os': '7.0.1',
      'x-device-id': 'aa843277-2fe6-4b68-a759-f305fab2ae67'
    };

    Map<String, String> body = {'mobile_no': mobile, 'password': password};

    Response response = await http.post('https://api.fitpass.dev/customer/loginwithsocialmedia', headers: headers, body: body);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      return null;
    }
  }

  Future<dynamic> getStudiosList(
      int userId, String appKey, double latitude, double longitude) async {
    Map<String, String> headers = {
      'x-appkey': appKey,
      'x-authkey': 'dgfJlO10QAoZzaiT8FXrF8bgBBQ5jghe7FNrd9t8D0u',
      'http-x-device-type': 'sfgsdhfsdhsd',
      'Content-Type': 'application/x-www-form-urlencoded',
      'device_token': 'kjjsfhsdkjfhdsfsadkfshdafsadfhsa',
      'x-user-id': userId.toString(),
      'x-device-type': 'Android',
      'x-app-version': '2.3',
      'x-device-name': 'Moto G4',
      'x-device-os': '7.0.1',
      'x-device-id': 'aa843277-2fe6-4b68-a759-f305fab2ae67'
    };

    print(headers);

    try {
      Response response = await http.get(
          'http://api.fitpass.dev/customer/studios?page_number=1&latitude=$latitude&longitude=$longitude',
          headers: headers);

      print(response);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        return null;
      }
    } catch(err){
      print(err);
    }
  }
}
