abstract class ISharedStorage{

  Future get(String key);
  Future delete(String key);
  Future put(String key, dynamic value);


  Future<int> getCounterValue();
  Future<void> saveCounterValue(int value);
}