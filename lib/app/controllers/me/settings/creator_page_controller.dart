import 'package:get/get.dart';
import '../../../models/creator_page_model.dart';

class CreatorPageController extends GetxController {
  var currentPageData = Rxn<HelpPageData>();
  var isLoading = false.obs;


  void loadPageData(String key) async {
    try {
      isLoading.value = true;
      currentPageData.value = null;

      await Future.delayed(const Duration(milliseconds: 300));

      currentPageData.value = _localData[key] ?? _localData['default'];
    } finally {
      isLoading.value = false;
    }
  }

  final Map<String, HelpPageData> _localData = {
    'careers':const HelpPageData(primaryBtn: 'Open positions',
        heroTitle: 'Become a NewsBreak creator!\nYour stories. Your spotlight',
        heroDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can\'t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms.',
        missionTitle: 'Calling all writers & video content creators.',
        missionDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can’t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms',
        statsTitle: 'What NewsBreak brings to you?',
        stats: _defaultStats),
    'contributor': const HelpPageData(primaryBtn: 'Become a Creator', secondaryBtn: 'Open NewsBreak', chip: 'Creator Program',
        heroTitle: 'Become a NewsBreak creator!\nYour stories. Your spotlight',
        heroDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can\'t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms.',
        missionTitle: 'Calling all writers & video content creators.',
        missionDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can’t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms',
        statsTitle: 'What NewsBreak brings to you?',
        stats: _defaultStats),
    'publish':const HelpPageData(primaryBtn: 'Apply to be a Partner', chip: 'Creator Program',
        heroTitle: 'Become a NewsBreak creator!\nYour stories. Your spotlight',
        heroDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can\'t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms.',
        missionTitle: 'Calling all writers & video content creators.',
        missionDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can’t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms',
        statsTitle: 'What NewsBreak brings to you?',
        stats: _defaultStats),
    'advertise':const HelpPageData(primaryBtn: 'Create an Ad', chip: 'Creator Program',
        heroTitle: 'Become a NewsBreak creator!\nYour stories. Your spotlight',
        heroDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can\'t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms.',
        missionTitle: 'Calling all writers & video content creators.',
        missionDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can’t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms',
        statsTitle: 'What NewsBreak brings to you?',
        stats: _defaultStats),
    'default': const HelpPageData(
        heroTitle: 'Become a NewsBreak creator!\nYour stories. Your spotlight',
        heroDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can\'t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms.',
        missionTitle: 'Calling all writers & video content creators.',
        missionDesc: 'Share your perspective on local life and turn everyday moments into stories your readers can’t wait to open. Build a loyal socials, deepen your connection, and keep your neighbors informed-on your terms',
        statsTitle: 'What NewsBreak brings to you?',
        stats: _defaultStats),
  };

static const List<Map<String, String>> _defaultStats = [
  {'number': '40+', 'label': 'Millions Users', 'desc': 'engage with NewsBreak every month across all touchpoints'},
  {'number': 'NO. 1', 'label': 'Ranked', 'desc': 'engage with NewsBreak every month across all touchpoints'},
  {'number': '1k+', 'label': 'Advertisers', 'desc': 'engage with NewsBreak every month across all touchpoints'},
];

}