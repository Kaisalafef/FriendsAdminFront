class OrderModel {
  final int id;
  final String customerName;
  final String location;
  final String governorate;
  final String city;
  final String serviceName;
  final String phone;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.location,
    required this.governorate,
    required this.city,
    required this.serviceName,
    required this.phone,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // جلب بيانات العميل من العلاقة المتداخلة 'user'
    final user = json['user'] ?? {};

    return OrderModel(
      id: json['id'],
      customerName: user['name'] ?? 'عميل غير معروف',
      location: json['address'] ?? user['city'] ?? 'غير محدد',
      governorate: user['governorate'] ?? '',
      city: user['city'] ?? '',
      // التحقق من نوع الخدمة أو المهنة
      serviceName: json['profession'] ??
          (json['service_type'] == 'image_request' ? 'طلب بصورة' : 'خدمة عامة'),
      phone: json['phone'] ?? user['phone'] ?? '',
      date: DateTime.parse(json['created_at']),
    );
  }
}