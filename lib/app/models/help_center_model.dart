class HelpArticle {
  final String title;
  final String? content;

  HelpArticle({required this.title, this.content});

}


class HelpCategory {
  final String name;
  final bool isClickable;

  HelpCategory({required this.name, this.isClickable = false});

}