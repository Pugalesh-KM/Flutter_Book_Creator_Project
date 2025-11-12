import 'widget_model.dart';

class PageModel {
  final String pageTitle;
  final int pageSizeX;
  final int pageSizeY;
  final String orientation;
  final List<WidgetData> widgets;

  PageModel({
    required this.pageTitle,
    required this.pageSizeX,
    required this.pageSizeY,
    required this.orientation,
    required this.widgets,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    final widgets = (json['widgets'] as List)
        .map((e) => WidgetData.fromJson(e))
        .toList();
    return PageModel(
      pageTitle: json['pageTitle'],
      pageSizeX: int.parse(json['page_size_X'].toString()),
      pageSizeY: int.parse(json['page_size_Y'].toString()),
      orientation: json['orientation'],
      widgets: widgets,
    );
  }

  Map<String, dynamic> toJson() => {
    'pageTitle': pageTitle,
    'page_size_X': pageSizeX,
    'page_size_Y': pageSizeY,
    'orientation': orientation,
    'widgets': widgets.map((e) => e.toJson()).toList(),
  };
}
