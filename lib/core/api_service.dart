

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'app_constants.dart';

class ApiService {
  ApiService._();

  static final GetStorage _storage = GetStorage();

  static Uri _buildUri(
      String endpoint, {
        Map<String, String>? queryParameters,
      }) {
    final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(queryParameters: queryParameters);
  }

  static Map<String, String> _headers({
    bool requiresAuth = false,
  }) {
    final token = _storage.read<String>(AppConstants.tokenKey);

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Accept-Language': AppConstants.defaultLanguage,
      if (requiresAuth && token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> getData({
    required String endpoint,
    Map<String, String>? queryParameters,
    bool requiresAuth = false,
  }) async {
    final response = await http
        .get(
      _buildUri(
        endpoint,
        queryParameters: queryParameters,
      ),
      headers: _headers(requiresAuth: requiresAuth),
    )
        .timeout(AppConstants.connectionTimeout);

    return response;
  }

  static Future<http.Response> postData({
    required String endpoint,
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    final response = await http
        .post(
      _buildUri(endpoint),
      headers: _headers(requiresAuth: requiresAuth),
      body: jsonEncode(body ?? {}),
    )
        .timeout(AppConstants.connectionTimeout);

    return response;
  }

  static Future<http.Response> putData({
    required String endpoint,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final response = await http
        .put(
      _buildUri(endpoint),
      headers: _headers(requiresAuth: requiresAuth),
      body: jsonEncode(body ?? {}),
    )
        .timeout(AppConstants.connectionTimeout);

    return response;
  }

  static Future<http.Response> deleteData({
    required String endpoint,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final response = await http
        .delete(
      _buildUri(endpoint),
      headers: _headers(requiresAuth: requiresAuth),
      body: body == null ? null : jsonEncode(body),
    )
        .timeout(AppConstants.connectionTimeout);

    return response;
  }

  static Future<http.Response> postMultipartData({
    required String endpoint,
    required String filePath,
    required String fileFieldName,
    Map<String, String>? fields,
    bool requiresAuth = true,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      _buildUri(endpoint),
    );

    final headers = _headers(requiresAuth: requiresAuth);
    headers.remove('Content-Type');

    request.headers.addAll(headers);

    if (fields != null) {
      request.fields.addAll(fields);
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        fileFieldName,
        filePath,
      ),
    );

    final streamedResponse = await request
        .send()
        .timeout(AppConstants.connectionTimeout);

    return await http.Response.fromStream(streamedResponse);
  }
}
