class WidgetData {
  final String type;
  final Map<String, dynamic> props;

  WidgetData({required this.type, required this.props});

  factory WidgetData.fromJson(Map<String, dynamic> json) {
    return WidgetData(type: json['type'], props: Map<String, dynamic>.from(json['props']));
  }

  Map<String, dynamic> toJson() => {'type': type, 'props': props};
}
