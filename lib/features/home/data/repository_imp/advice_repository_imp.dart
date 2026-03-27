import 'package:gps_native_clean_architecture/features/home/data/data_source/advice_data_source.dart';
import 'package:gps_native_clean_architecture/features/home/domain/entity/advice_entity.dart';
import 'package:gps_native_clean_architecture/features/home/domain/repository/advice_repository.dart';

class AdviceRepositoryImpl implements AdviceRepository {
  final AdviceRemoteDataSource source;

  AdviceRepositoryImpl(this.source);

  @override
  Future<AdviceEntity> getAdvice() async {
    final model = await source.getAdvice();
    return model.toEntity();
  }
}
