class HelpPageData {
  final String? primaryBtn;
  final String? secondaryBtn;
  final String chip;
  final String heroTitle;
  final String heroDesc;
  final String missionTitle;
  final String missionDesc;
  final String statsTitle;
  final List<Map<String, String>> stats;

  const HelpPageData({
    this.primaryBtn,
    this.secondaryBtn,
    this.chip = 'Our Mission',
    this.heroTitle = '',
    required this.heroDesc,
    required this.missionTitle,
    required this.missionDesc,
    required this.statsTitle,
    this.stats = const [],
  });
}