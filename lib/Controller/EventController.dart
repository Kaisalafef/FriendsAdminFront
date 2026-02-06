import 'package:friends_admin/Model/EventModel.dart';
import 'package:friends_admin/core/api/dio_client.dart';
import 'package:get/get.dart';
class EventsController extends GetxController {
  var isLoading = true.obs;
  var eventsList = <EventModel>[].obs;
  final DioClient _dioClient = DioClient();
  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  Future<void>  fetchEvents() async {
    try {
      isLoading(true);
      // طلب GET للرابط /events
      var response = await _dioClient.get('/events');

      if (response.statusCode == 200) {
        // بما أن الباك اند يستخدم paginate(10)، البيانات تكون داخل 'data'
        var jsonData = response.data;
        var data = jsonData['data'] as List;

        eventsList.value = data.map((e) => EventModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading(false);
    }
  }
}