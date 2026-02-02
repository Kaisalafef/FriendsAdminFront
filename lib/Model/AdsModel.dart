class AdModel {
  final int id;
  final String? title;
  final String? description;
  final String? image;
  final String? governorate;
  final String? city; // أضفت المدينة لأنها موجودة في الباك إند

  AdModel({
    required this.id,
    this.title,
    this.description,
    this.image,
    this.governorate,
    this.city,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] ?? 0, // إضافة قيمة افتراضية لتجنب خطأ الـ Null
      title: json['title'],
      description: json['description'],
      image: json['image'],
      governorate: json['governorate'],
      city: json['city'],
    );
  }

  // دالة مطورة للحصول على رابط الصورة
  String get fullImageUrl {
    if (image == null || image!.isEmpty) {
      return "https://via.placeholder.com/400x200"; // صورة بديلة
    }
    
    // ملاحظة: تأكد أن الـ IP هو نفس الـ IP الموجود في DioClient
    const String baseUrl = "http://192.168.0.107:8000"; 
    return "$baseUrl/storage/$image";
  }
}