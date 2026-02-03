import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/AddAdController.dart';
import '../../constence/MyColor.dart';

// قائمة محافظات العراق
final List<String> iraqCities = [
  "بغداد",
  "البصرة",
  "نينوى",
  "أربيل",
  "السليمانية",
  "دهوك",
  "كركوك",
  "الأنبار",
  "بابل",
  "كربلاء",
  "النجف",
  "ذي قار",
  "واسط",
  "ديالى",
  "صلاح الدين",
  "المثنى",
  "القادسية",
  "ميسان",
];

class AddAdPage extends StatelessWidget {
  final AddAdController controller = Get.put(AddAdController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إنشاء إعلان جديد",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.primaryBlue,
        elevation: 0,
      ),
      body: GetBuilder<AddAdController>(builder: (controller) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // اختيار الصورة
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: MyColor.primaryBlue.withOpacity(0.3),
                    ),
                  ),
                  child: controller.selectedImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: MyColor.primaryBlue,
                      ),
                      Text("اضغط لإضافة صورة الإعلان"),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      controller.selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // عنوان الإعلان
              _buildInput(
                controller.titleController,
                "عنوان الإعلان",
                Icons.title,
              ),

              const SizedBox(height: 15),

              // اختيار المحافظة (Dropdown)
              DropdownButtonFormField<String>(
                value: controller.cityController.text.isEmpty
                    ? null
                    : controller.cityController.text,
                decoration: InputDecoration(
                  hintText: "اختر المحافظة",
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: MyColor.primaryBlue,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                    BorderSide(color: MyColor.primaryBlue),
                  ),
                ),
                items: iraqCities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.cityController.text = value ?? "";
                },
              ),

              const SizedBox(height: 15),

              // وصف الإعلان
              _buildInput(
                controller.descriptionController,
                "وصف الإعلان",
                Icons.description,
                maxLines: 4,
              ),

              const SizedBox(height: 30),

              controller.isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColor.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: controller.uploadAd,
                  child: Text(
                    "نشر الإعلان الآن",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInput(
      TextEditingController ctr,
      String hint,
      IconData icon, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: ctr,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: MyColor.primaryBlue,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: MyColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}
