import 'package:gps_native_clean_architecture/features/home/domain/entity/advice_entity.dart';
import 'package:gps_native_clean_architecture/features/home/domain/repository/advice_repository.dart';

class GetMultipleAdvicesUseCase {
  final AdviceRepository repository;

  GetMultipleAdvicesUseCase(this.repository);

  Future<AdviceEntity> call() {
    return repository.getAdvice();
  }
}
