import 'package:gps_native_clean_architecture/core/data/data_source/local/app_hive.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

const _boxName = 'app_local_storage';

class AppHiveImpl implements AppHive {
  AppHiveImpl._();

  // Tạm thời sử dụng singleton để tránh thay đổi quá nhiều code
  // TODO: Bỏ singleton để chuyển về dependency injection bình thường
  @Deprecated(
      "Không dùng trực tiếp qua AppHive.instance, dùng thông qua sl() để inject vào các class cần thiết")
  static final AppHiveImpl instance = AppHiveImpl._();

  late final Box _box;

  Future<AppHiveImpl> init() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    Hive.init(documentsDir.path);
    // Register adapters here:
    // Hive.registerAdapter(YourAdapter());
    // Hive.registerAdapter(AnotherAdapter());

    _box = await Hive.openBox(_boxName);
    return this;
  }

  @override
  Future<void> put(String key, dynamic value) => _box.put(key, value);

  @override
  T? get<T>(String key) => _box.get(key);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<int> deleteAll() => _box.clear();

  @override
  Future<void> deleteKeys(List<String> keys) => _box.deleteAll(keys);
}
