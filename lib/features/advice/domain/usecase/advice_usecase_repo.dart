import 'package:flutter_getx_clean_architecture/features/advice/domain/entity/advice_entity.dart';
import 'package:flutter_getx_clean_architecture/features/advice/domain/repository/repository.dart';

class GetMultipleAdvicesUseCase {
  final AdviceRepository repository;

  GetMultipleAdvicesUseCase(this.repository);

  Future<AdviceEntity> call() {
    return repository.getAdvice();
  }
}
