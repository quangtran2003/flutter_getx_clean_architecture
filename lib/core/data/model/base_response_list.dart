import 'package:flutter_getx_clean_architecture/shared/constants/const.dart';

class BaseResponseList<T> {
  final String? code;
  final String? errorMessage;
  final List<T> result;

  BaseResponseList({
    required this.code,
    this.errorMessage,
    required this.result,
  });

  factory BaseResponseList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final result = json["result"];
    return BaseResponseList<T>(
      code: json['code'] as String?,
      errorMessage: json['errorMessage'] as String?,
      result: (result as List<dynamic>)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get isSuccess => code == responseCodeSuccess;
}
