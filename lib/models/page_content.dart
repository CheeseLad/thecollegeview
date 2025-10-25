class PageContent {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String link;
  final String slug;

  PageContent({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.link,
    required this.slug,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
      id: json['id'] ?? 0,
      title: json['title']?['rendered'] ?? '',
      content: json['content']?['rendered'] ?? '',
      excerpt: json['excerpt']?['rendered'] ?? '',
      link: json['link'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class ContactInfo {
  final String editorInChief;
  final String editorInChiefEmail;
  final String deputyEditor;
  final String deputyEditorEmail;
  final String newsEditors;
  final String newsEmail;
  final String opinionFeaturesEditors;
  final String opinionEmail;
  final String featuresEmail;
  final String sportsEditors;
  final String sportsEmail;
  final String lifestyleEditors;
  final String lifestyleEmail;
  final String hypeEditors;
  final String hypeEmail;
  final String satireEditors;
  final String satireEmail;
  final String irishEditors;
  final String irishEmail;
  final String productionEmail;
  final String webmaster;
  final String webmasterEmail;

  ContactInfo({
    required this.editorInChief,
    required this.editorInChiefEmail,
    required this.deputyEditor,
    required this.deputyEditorEmail,
    required this.newsEditors,
    required this.newsEmail,
    required this.opinionFeaturesEditors,
    required this.opinionEmail,
    required this.featuresEmail,
    required this.sportsEditors,
    required this.sportsEmail,
    required this.lifestyleEditors,
    required this.lifestyleEmail,
    required this.hypeEditors,
    required this.hypeEmail,
    required this.satireEditors,
    required this.satireEmail,
    required this.irishEditors,
    required this.irishEmail,
    required this.productionEmail,
    required this.webmaster,
    required this.webmasterEmail,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      editorInChief: json['editor_in_chief'] ?? '',
      editorInChiefEmail: json['editor_in_chief_email'] ?? '',
      deputyEditor: json['deputy_editor'] ?? '',
      deputyEditorEmail: json['deputy_editor_email'] ?? '',
      newsEditors: json['news_editors'] ?? '',
      newsEmail: json['news_email'] ?? '',
      opinionFeaturesEditors: json['opinion_features_editors'] ?? '',
      opinionEmail: json['opinion_email'] ?? '',
      featuresEmail: json['features_email'] ?? '',
      sportsEditors: json['sports_editors'] ?? '',
      sportsEmail: json['sports_email'] ?? '',
      lifestyleEditors: json['lifestyle_editors'] ?? '',
      lifestyleEmail: json['lifestyle_email'] ?? '',
      hypeEditors: json['hype_editors'] ?? '',
      hypeEmail: json['hype_email'] ?? '',
      satireEditors: json['satire_editors'] ?? '',
      satireEmail: json['satire_email'] ?? '',
      irishEditors: json['irish_editors'] ?? '',
      irishEmail: json['irish_email'] ?? '',
      productionEmail: json['production_email'] ?? '',
      webmaster: json['webmaster'] ?? '',
      webmasterEmail: json['webmaster_email'] ?? '',
    );
  }
}
