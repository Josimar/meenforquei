import 'package:meenforquei/interfaces/shared_storage_interface.dart';

class StorageServiceFake extends ISharedStorage{
  @override
  Future<int> getCounterValue() async {
    return 11;
  }

  @override
  Future<void> saveCounterValue(int value) {
    return null;
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