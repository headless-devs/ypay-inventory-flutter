final class SimpleWidgetRenderData {
  const SimpleWidgetRenderData({
    this.types = const {YPayWidgetType.split, YPayWidgetType.cashback},
    this.theme = YPayWidgetTheme.system,
    this.style = YPayWidgetStyle.solid,
  });

  final Set<YPayWidgetType> types;
  final YPayWidgetTheme theme;
  final YPayWidgetStyle style;

  Map<String, dynamic> creationParams() {
    return {
      'types': types.map((type) => type.name).toList(),
      'theme': theme.name,
      'style': style.name,
    };
  }
}

/// Widget's type. You can configure the widget to upload
/// the split info, the cashback info or both
enum YPayWidgetType {
  split,
  cashback,
}

/// Widget's coloring theme. You may choose to set the dark theme,
/// the light theme, or respect the theme, set in the system
enum YPayWidgetTheme { light, dark, system }

/// Background style for the widget. You may choose to
/// set solid color or leave the widget transparent.
enum YPayWidgetStyle {
  solid,
  transparent,
}
