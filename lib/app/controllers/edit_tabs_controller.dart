import 'package:get/get.dart';
import 'home_controller.dart';

class EditTabsController extends GetxController {
  final RxList<String> selectedTopics = <String>[].obs;
  final RxList<String> allTopics = <String>[].obs;

  static const List<String> _allPossible = [
    'reactions', 'for_you', 'local', 'local_tv',
    'entertainment', 'sports', 'food', 'health', 'beauty', 'weather'
  ];

  @override
  void onInit() {
    super.onInit();
    final homeController = Get.find<HomeController>();
    selectedTopics.assignAll(homeController.tabs);
    allTopics.assignAll(
      _allPossible.where((t) => !selectedTopics.contains(t)).toList(),
    );
  }

  void removeFromSelected(String topic) {
    selectedTopics.remove(topic);
    final insertIndex = _allPossible
        .where((t) => !selectedTopics.contains(t))
        .toList()
        .indexOf(topic);
    if (insertIndex >= 0 && insertIndex <= allTopics.length) {
      allTopics.insert(insertIndex, topic);
    } else {
      allTopics.add(topic);
    }
  }

  void addToSelected(String topic) {
    allTopics.remove(topic);
    selectedTopics.add(topic);
  }

  void onSave() {
    final homeController = Get.find<HomeController>();

    final sorted = _allPossible
        .where((t) => selectedTopics.contains(t))
        .toList();

    homeController.tabs.assignAll(sorted);

    if (homeController.selectedTabIndex.value >= sorted.length) {
      homeController.selectedTabIndex.value = 0;
    }
    Get.back();
  }


  void onCancel() => Get.back();

}