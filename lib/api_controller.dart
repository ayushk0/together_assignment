import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:together_assignment/discovery_model.dart';

class ApiController {
  Future<DiscoveryModel?> dashboard({required int page}) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api-stg.together.buzz/mocks/discovery?page=$page&limit=10'));

    http.StreamedResponse response = await request.send();
    var res = DiscoveryModel.fromJson(
        jsonDecode(await response.stream.bytesToString()));

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return res;
    } else {
      print(response.reasonPhrase);
      return null;
    }
  }
}
