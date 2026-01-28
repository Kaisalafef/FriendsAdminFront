class OrderModel {
  final String id;
  final String customerName;
  final String location;     // العنوان التفصيلي
  final String governorate;  // المحافظة (للفلترة)
  final String city;         // المدينة (للفلترة)
  final String serviceName;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.location,
    required this.governorate,
    required this.city,
    required this.serviceName,
    required this.date,
  });
}