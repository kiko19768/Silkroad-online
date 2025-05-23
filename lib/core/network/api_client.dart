import 'package:dio/dio.dart';
import 'package:arabic_mmorpg/config/app_config.dart';
import 'package:arabic_mmorpg/core/error/exceptions.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio) {
    _dio.options.baseUrl = AppConfig.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add common headers
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          
          // Add auth token if available
          final String? token = _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          return handler.next(_handleError(e));
        },
      ),
    );
  }
  
  String? _getAuthToken() {
    // Implement token retrieval from secure storage
    return null;
  }
  
  DioException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const TimeoutException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            throw BadRequestException(
              message: error.response?.data['message'] ?? 'Bad request',
            );
          case 401:
            throw UnauthorizedException(
              message: error.response?.data['message'] ?? 'Unauthorized',
            );
          case 403:
            throw ForbiddenException(
              message: error.response?.data['message'] ?? 'Forbidden',
            );
          case 404:
            throw NotFoundException(
              message: error.response?.data['message'] ?? 'Not found',
            );
          case 500:
          case 501:
          case 502:
          case 503:
            throw ServerException(
              message: error.response?.data['message'] ?? 'Server error',
            );
          default:
            throw const UnexpectedException();
        }
      case DioExceptionType.cancel:
        throw const RequestCancelledException();
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          throw const NoInternetException();
        }
        throw const UnexpectedException();
      default:
        throw const UnexpectedException();
    }
  }
  
  // GET request
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // POST request
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // PUT request
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // DELETE request
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
  
  // PATCH request
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
}