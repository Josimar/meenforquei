import 'package:meenforquei/interfaces/shared_storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServiceSharedPreferences extends ISharedStorage{

  @override
  Future delete(String key) async {
    var shared = await SharedPreferences.getInstance();
    shared.remove(key);
  }

  @override
  Future get(String key) async {
    var shared = await SharedPreferences.getInstance();
    return shared.get(key);
  }

  @override
  Future put(String key, value) async {
    var shared = await SharedPreferences.getInstance();
    if (value is bool){
      shared.setBool(key, value);
    }else if (value is String){
      shared.setString(key, value);
    }else if (value is int){
      shared.setInt(key, value);
    }else if (value is double){
      shared.setDouble(key, value);
    }
  }

  @override
  Future<int> getCounterValue() async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('counter_int_key') ?? 0;

  }

  @override
  Future<void> saveCounterValue(int value) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter_int_key', value);

  }

}