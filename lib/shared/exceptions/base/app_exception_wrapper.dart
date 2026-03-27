import 'package:gps_native_clean_architecture/shared/exceptions/base/app_exception.dart';
import 'package:gps_native_clean_architecture/shared/exceptions/remote/remote_exception.dart';

class AppExceptionWrapper {
  AppExceptionWrapper({
    required this.appException,
    this.stackTrace,
    this.overrideMessage,
  });

  final AppException appException;
  final StackTrace? stackTrace;
  final String? overrideMessage;

  @override
  String toString() {
    return 'AppExceptionWrapper(appExceptionType: ${appException.appExceptionType}, overrideMessage: $overrideMessage, stackTrace: $stackTrace)';
  }

  bool get connectToSeverFailed {
    if (appException.appExceptionType == AppExceptionType.remote) {
      final exception = appException as RemoteException;
      return exception.kind == RemoteExceptionKind.noInternet ||
          exception.kind == RemoteExceptionKind.timeout ||
          exception.kind == RemoteExceptionKind.network;
    }

    return false;
  }
}
