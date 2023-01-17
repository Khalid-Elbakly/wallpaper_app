import 'package:hive_flutter/hive_flutter.dart';

class CacheHelper {
  static Box? box;

  static Future<void> initCache() async {
    box = await Hive.openBox('testBox');
  }

  static void putData(String name, value) {
    box!.put(name, value);
  }

  static void deleteData(String name) {
    box!.delete(name);
  }

  static List getData(String name) {
    return box!.get(name,defaultValue: []);
  }

  static clearData() {
    return box!.clear();
  }
}
