import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:raid/provider/CasheManger.dart';

class Api {
  static final _api = Api._internal();

  factory Api() {
    return _api;
  }
  Api._internal();

  ///  Temporrary*****************************************

  ///*****************************************************
  String baseUrl = 'fsdmarketing.com';
  String path = '/alraayid/api';

  Future<http.Response> httpGet(String endPath,
      {Map<String, String> query}) async {
    String token = await CacheManger().getToken();
    print(token);
    Uri uri = Uri.https(baseUrl, '$path/$endPath');
    if (query != null) {
      uri = Uri.https(baseUrl, '$path/$endPath', query);
    }
    return http.get(uri, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  Future<http.Response> httpPost(String endPath, Object body) async {
    String token = await CacheManger().getToken();
    print(token);
    Uri uri = Uri.https(baseUrl, '$path/$endPath');
    print('${uri.toString()}  ${body}');
    return http.post(uri, body: body, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  Future<http.Response> httpPostWithFile(String endPath, {File file}) async {
    String token = await CacheManger().getToken();
    print(token);
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    Uri uri = Uri.https(baseUrl, '$path/$endPath');
    var length = await file.length();
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        http.MultipartFile('file', file.openRead(), length,
            filename: basename(file.path)),
      );
    return await http.Response.fromStream(await request.send())
        .timeout(Duration(seconds: 10));
  }
}
