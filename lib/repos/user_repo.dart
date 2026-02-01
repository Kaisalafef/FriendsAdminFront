import '../core/api/dio_client.dart';

class UserRepository {
  final DioClient _dioClient = DioClient();

  Future<List<dynamic>> fetchUsers() async {
    try {
      // استدعاء الراوت فقط بدون الرابط الأساسي
      final response = await _dioClient.get('/users');

      if (response.statusCode == 200) {
        // الوصول للبيانات القادمة من لارافيل
        return response.data['data']; 
      } else {
        throw Exception('فشل تحميل البيانات');
      }
    } catch (e) {
      rethrow;
    }
  }
}