import 'dart:convert';
import 'package:http/http.dart';
import 'package:logger/web.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, null);
      Response response = await get(uri);
      _logResponse(url, response);

      

      final int statusCode = response.statusCode;

      if (response.statusCode == 200) {
        //SUCCESS
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else {
        //FAILED
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }
  
  static Future<ApiResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body);
      Response response = await post(uri, 
      headers: {'content-type': 'application/json'},
      body: jsonEncode(body));
      _logResponse(url, response);

      

      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 201) {
        //SUCCESS
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: true,
          responseCode: statusCode,
          responseData: decodedData,
        );
      } else {
        //FAILED
        final decodedData = jsonDecode(response.body);
        return ApiResponse(
          isSuccess: false,
          responseCode: statusCode,
          responseData: decodedData,
        );
      }
    } on Exception catch (e) {
      return ApiResponse(
        isSuccess: false,
        responseCode: -1,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  static void _logRequest(String url, Map<String, dynamic>? body) {
    _logger.i('UR: => $url\n'
    'Request Body: $body');
  }

  static void _logResponse(String url, Response response) {
    _logger.i(
      'UR: => $url\n'
      'Status Code: ${response.statusCode}\n'
      'Body: ${response.body}',
    );
  }
}

class ApiResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.responseCode,
    required this.responseData,
    this.errorMessage = 'Something went wrong.',
  });
}
