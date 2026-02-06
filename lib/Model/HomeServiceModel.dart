class HomeServiceModel {
  final int id;
  final String serviceType; // image_request أو direct_request
  final String? description;
  final String? profession;
  final String? phone;
  final String? address;
  final String userName; // اسم العميل
  final List<String> images; // قائمة روابط الصور

  HomeServiceModel({
    required this.id,
    required this.serviceType,
    this.description,
    this.profession,
    this.phone,
    this.address,
    required this.userName,
    required this.images,
  });

  factory HomeServiceModel.fromJson(Map<String, dynamic> json) {
    return HomeServiceModel(
      id: json['id'],
      serviceType: json['service_type'] ?? 'direct_request',
      description: json['description'] ?? 'لا يوجد وصف',
      profession: json['profession'],
      phone: json['phone'] ?? '',
      address: json['address'] ?? 'غير محدد',
      // جلب اسم المستخدم من العلاقة user، إذا لم يوجد نضع "عميل"
      userName: json['user'] != null ? json['user']['name'] : 'عميل',
      // معالجة الصور
      images: json['images'] != null
          ? (json['images'] as List).map((e) => e['image_path'].toString()).toList()
          : [],
    );
  }
}