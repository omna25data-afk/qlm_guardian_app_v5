import 'package:dio/dio.dart';

/// Retry interceptor - retries failed requests with exponential backoff
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<int> retryStatusCodes;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryStatusCodes = const [
      408, // Request Timeout
      500, // Internal Server Error
      502, // Bad Gateway
      503, // Service Unavailable
      504, // Gateway Timeout
    ],
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Don't retry if not a network error or non-retryable status
    if (err.type != DioExceptionType.badResponse &&
        err.type != DioExceptionType.connectionTimeout &&
        err.type != DioExceptionType.receiveTimeout) {
      handler.next(err);
      return;
    }

    final statusCode = err.response?.statusCode;
    if (statusCode != null && !retryStatusCodes.contains(statusCode)) {
      handler.next(err);
      return;
    }

    // Get current retry count
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    // Exponential backoff: 1s, 2s, 4s
    final delay = Duration(seconds: (1 << retryCount));
    await Future.delayed(delay);

    // Retry the request
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}
