import 'package:flutter_getx_clean_architecture/core/data/data_source/network/non_auth_app_server_api_client.dart';
import 'package:flutter_getx_clean_architecture/core/data/data_source/network/rest_api_client.dart';
import 'package:flutter_getx_clean_architecture/features/advice/core/api.dart';
import 'package:flutter_getx_clean_architecture/features/advice/data/model/advice_model.dart';

abstract class AdviceRemoteDataSource {
  Future<AdviceModel> getAdvice();
  
}

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final NonAuthAppServerApiClient _nonAuthAppServerApiClient;

  AdviceRemoteDataSourceImpl(
    this._nonAuthAppServerApiClient,
  );

  @override
  Future<AdviceModel> getAdvice() async {
    final response = await _nonAuthAppServerApiClient.request(
      method: RestMethod.get,
      path: AppApi.adviceUrl,
    );

    return AdviceModel.fromJson(response) ;
  }
}
