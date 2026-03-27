import 'package:gps_native_clean_architecture/features/home/domain/entity/advice_entity.dart';

abstract class AdviceRepository {
  Future<AdviceEntity> getAdvice();
}
