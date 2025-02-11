import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import '../../../models/api_response.dart';
import 'api_constants.dart';

@singleton
class ApiService {
  Future<ApiResponse<String>> executeGET(
      {required String endpoint, Map<String, dynamic>? params}) async {
    var uri = Uri.https(ApiConstants.baseUrl, endpoint, params);

    var response = await http.get(uri);

    if (response.statusCode == 200) {
      return ApiResponse<String>(
        data: response.body,
        statusCode: response.statusCode,
        message: 'Success',
      );
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<ApiResponse<String>> fetchUsersData(
      {required int limit, required int skip}) async {
    var endpoint = ApiConstants.userEndpoint;
    var queryParameters = {
      'limit': '$limit',
      'skip': '$skip',
    };
    var rs = await executeGET(endpoint: endpoint, params: queryParameters);
    return rs;
  }
}
