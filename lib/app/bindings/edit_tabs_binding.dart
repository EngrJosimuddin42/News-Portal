import 'package:get/get.dart';
import '../controllers/edit_tabs_controller.dart';

class EditTabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditTabsController>(() => EditTabsController());
  }
}