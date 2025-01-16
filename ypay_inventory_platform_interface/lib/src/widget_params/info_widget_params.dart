import 'simple_widget_params.dart';

final class InfoWidgetRenderData {
  const InfoWidgetRenderData({
    this.types = const {YPayWidgetType.split, YPayWidgetType.cashback},
    this.theme = YPayWidgetTheme.system,
  });

  final Set<YPayWidgetType> types;
  final YPayWidgetTheme theme;

  Map<String, dynamic> creationParams() {
    return {
      'types': types.map((type) => type.name).toList(),
      'theme': theme.name,
    };
  }
}
