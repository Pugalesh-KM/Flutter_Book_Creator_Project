enum PageLayout { oneColumn, twoColumns }

class WidgetData {
  final String type;
  final Map<String, dynamic> props;

  WidgetData({required this.type, required this.props});

  Map<String, dynamic> toJson() => {'type': type, 'props': props};

  factory WidgetData.text(String text, {int fontSize = 16, String color = '#333333'}) =>
      WidgetData(type: 'Text', props: {'text': text, 'fontSize': fontSize, 'color': color});

  factory WidgetData.image(String url) => WidgetData(type: 'Image', props: {'url': url});

  factory WidgetData.video(String url) => WidgetData(type: 'Video', props: {'url': url});

  factory WidgetData.liveData(String data) => WidgetData(type: 'LiveData', props: {'data': data});

  factory WidgetData.fromJson(Map<String, dynamic> json) => WidgetData(type: json['type'] as String, props: Map<String, dynamic>.from(json['props'] ?? {}));
}

class PageModel {
  final String pageTitle;
  final int pageSizeX;
  final int pageSizeY;
  final PageLayout layout;
  final List<WidgetData> widgets;

  PageModel({required this.pageTitle, required this.pageSizeX, required this.pageSizeY, required this.layout, required this.widgets});

  factory PageModel.sample({String title = 'Untitled', PageLayout layout = PageLayout.twoColumns}) =>
      PageModel(pageTitle: title, pageSizeX: 800, pageSizeY: 1000, layout: layout, widgets: []);

  PageModel copyWith({String? pageTitle, int? pageSizeX, int? pageSizeY, PageLayout? layout, List<WidgetData>? widgets}) {
    return PageModel(
      pageTitle: pageTitle ?? this.pageTitle,
      pageSizeX: pageSizeX ?? this.pageSizeX,
      pageSizeY: pageSizeY ?? this.pageSizeY,
      layout: layout ?? this.layout,
      widgets: widgets ?? this.widgets,
    );
  }

  Map<String, dynamic> toJson() => {
    'pageTitle': pageTitle,
    'page_size_X': pageSizeX,
    'page_size_Y': pageSizeY,
    'layout': layout == PageLayout.twoColumns ? 'two' : 'one',
    'widgets': widgets.map((w) => w.toJson()).toList(),
  };
}

class BookModel {
  final String title;
  final List<PageModel> pages;

  BookModel({required this.title, required this.pages});

  BookModel copyWith({String? title, List<PageModel>? pages}) => BookModel(title: title ?? this.title, pages: pages ?? this.pages);

  Map<String, dynamic> toJson() => {'title': title, 'pages': pages.map((p) => p.toJson()).toList()};
}
