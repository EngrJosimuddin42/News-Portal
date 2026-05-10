import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_break/app/widgets/app_snackbar.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../theme/app_colors.dart';

class EditProfileController extends GetxController {
  // Text Controllers
  late TextEditingController nameController;
  late TextEditingController userNameController;
  late TextEditingController bioController;
  late TextEditingController websiteController;
  late TextEditingController emailController;

  // Observable Variables
  var isLoading = false.obs;
  var selectedGender = 'Female'.obs;
  var selectedBirthDate = DateTime(2005, 12, 12).obs;

  final List<String> genders = [
    'Female',
    'Male',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  void onInit() {
    super.onInit();
    final user = AuthController.to.user.value;
    nameController = TextEditingController(text: user?.name ?? '');
    userNameController = TextEditingController(text: user?.username ?? '');
    bioController = TextEditingController(text: user?.bio ?? '');
    websiteController = TextEditingController(text: user?.website ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    selectedGender.value = user?.gender ?? 'Female';

    if (user?.birthYear != null && user!.birthYear!.isNotEmpty) {
      try {
        selectedBirthDate.value = DateFormat('dd/MM/yyyy').parse(user.birthYear!);
      } catch (e) {
        selectedBirthDate.value = DateTime(2005, 12, 12);
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    userNameController.dispose();
    bioController.dispose();
    websiteController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Gender Update Function
  void updateGender(String gender) {
    selectedGender.value = gender;
  }

  // Birth Date Picker Logic
  Future<void> chooseBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate.value,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                  primary: AppColors.linkColor,
                  onPrimary: Colors.white,
                  surface: const Color(0xFF242424),
                  onSurface: Colors.white),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(foregroundColor: AppColors.linkColor))),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedBirthDate.value) {
      selectedBirthDate.value = picked;
    }
  }


  // API Save Profile Logic
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;

      AuthController.to.updateProfile(
        name: nameController.text,
        username: userNameController.text,
        email: emailController.text,
        bio: bioController.text,
        website: websiteController.text,
        gender: selectedGender.value,
        birthYear: DateFormat('dd/MM/yyyy').format(selectedBirthDate.value),
        newImageUrl: AuthController.to.user.value?.profileImageUrl);

      Get.back();
      AppSnackbar.success(message: 'Profile updated successfully');

    } catch (e) {
      AppSnackbar.error(message: 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}