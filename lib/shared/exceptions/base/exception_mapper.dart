import 'package:gps_native_clean_architecture/shared/exceptions/base/app_exception.dart';

abstract class ExceptionMapper<T extends AppException> {
  const ExceptionMapper();
  T map(Object? exception);
}
