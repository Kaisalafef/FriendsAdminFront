import 'package:dio/dio.dart';
import '../services/token_service.dart'; // استدعاء ملف التوكن

class DioClient {
  final String baseUrl = "http://192.168.1.103:8000/api";
  final TokenService _tokenService = TokenService(); // تعريف خدمة التوكن
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // إضافة Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // جلب التوكن المحفوظ
          final token = await _tokenService.getToken();
          
          // إذا وجد التوكن، أضفه للهيدر
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options); // تابع الطلب
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // هنا يمكنك التعامل مع انتهاء صلاحية التوكن (مثلاً تسجيل خروج تلقائي)
            print("Unauthenticated: Token expired or invalid");
          }
          return handler.next(e);
        },
      ),
    );

    // للمراقبة (Logs)
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  // الدوال المساعدة GET, POST
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
  Future<Response> delete(String path, {dynamic data}) async {
    return await _dio.delete(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
}