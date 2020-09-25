import 'dart:convert';
import 'package:http/http.dart';
import 'package:meenforquei/interfaces/shared_storage_interface.dart';


class StorageServiceWeb extends ISharedStorage{
  @override
  Future<int> getCounterValue()  async {
    String url = 'https://example.com/counter';
    Response response = await get(url);
    String json = response.body;
    Map<String, dynamic> map = jsonDecode(json);
    int counterValue = map['counter'];
    return counterValue;
  }

  @override
  Future<void> saveCounterValue(int value) async {
    String url = 'https://example.com/counter';
    Map<String, String> headers = {'Content-type': 'application/json'};
    String json = '{"counter": $value}';
    await post(url, headers: headers, body: json);
  }

  @override
  Future delete(String key) {
    return null;
  }

  @override
  Future get(String key) {
    return null;
  }

  @override
  Future put(String key, value) {
    return null;
  }


}