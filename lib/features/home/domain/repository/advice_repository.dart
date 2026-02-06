import 'package:flutter_getx_clean_architecture/features/home/domain/entity/advice_entity.dart';

abstract class AdviceRepository {
  Future<AdviceEntity> getAdvice();
}
