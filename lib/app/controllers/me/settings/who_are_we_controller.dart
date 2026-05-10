import 'package:get/get.dart';
import '../../../models/who_are_we_model.dart';

class WhoAreWeController extends GetxController {

  var aboutSections = <AboutSection>[].obs;
  var teamList = <TeamMember>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  void fetchAllData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    var aboutData = [
      AboutSection(
        chip: 'About Us',
        title: "We're NewsBreak",
        desc: 'Lorem ipsum dolor sit amet consectetur. Lectus bibendum eu mauris praesent eu iaculis. Elit ac in quam purus.',
        image: 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=600',
      ),
      AboutSection(
        chip: 'Our Story',
        title: "The Journey",
        desc: 'Lorem ipsum dolor sit amet consectetur. Lectus bibendum eu mauris praesent eu iaculis. Elit ac in quam purus.',
        image: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=600',
      ),
    ];


    var teamData = [
      TeamMember(
        name: 'Wynston Alberts',
        role: 'Trust & Safety',
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
          bio:'Lorem ipsum dolor sit amet consectetur. Pulvinar vestibulum ipsum nulla id. Volutpat mattis et integer porttitor. Neque non tempor ante bibendum ipsum non.'
      ),
      TeamMember(
          name: 'Wynston Alberts',
          role: 'Trust & Safety',
          imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
          bio:'Lorem ipsum dolor sit amet consectetur. Pulvinar vestibulum ipsum nulla id. Volutpat mattis et integer porttitor. Neque non tempor ante bibendum ipsum non.'
      ),
    ];

    aboutSections.assignAll(aboutData);
    teamList.assignAll(teamData);
    isLoading.value = false;
  }
}