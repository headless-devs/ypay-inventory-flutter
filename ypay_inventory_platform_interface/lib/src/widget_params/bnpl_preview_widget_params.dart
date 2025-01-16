import 'dart:ui';

import 'simple_widget_params.dart';

final class BnplPreviewWidgetRenderData {
  const BnplPreviewWidgetRenderData({
    this.theme = YPayWidgetTheme.system,
    this.header = YPayWidgetHeader.standard,
    this.background = YPayWidgetBackground.standard,
    this.backgroundColor,
    this.hasOutline = true,
    this.radius = 30,
    this.hasPadding = true,
    this.size = YPayWidgetSize.medium,
    this.hasCheckoutButton = false,
  });

  const BnplPreviewWidgetRenderData.customBackground({
    this.theme = YPayWidgetTheme.system,
    this.header = YPayWidgetHeader.standard,
    required Color this.backgroundColor,
    this.hasOutline = true,
    this.radius = 30,
    this.hasPadding = true,
    this.size = YPayWidgetSize.medium,
    this.hasCheckoutButton = false,
  }) : background = YPayWidgetBackground.custom;

  final YPayWidgetTheme theme;
  final YPayWidgetHeader header;
  final YPayWidgetBackground background;
  final Color? backgroundColor;
  final bool hasOutline;

  /// Перевод в dp
  final double radius;
  final bool hasPadding;
  final YPayWidgetSize size;
  final bool hasCheckoutButton;

  Map<String, dynamic> creationParams() {
    return {
      'theme': theme.name,
      'header': header.name,
      'background': background.name,
      'backgroundColor':
          background == YPayWidgetBackground.custom ? backgroundColor?.value.toRadixString(16).padLeft(8, '0') : null,
      'hasOutline': hasOutline,
      'radius': radius,
      'hasPadding': hasPadding,
      'size': size.name,
      'hasCheckoutButton': hasCheckoutButton,
    };
  }
}

/// Background options for the widget. You can choose a standard look,
/// make the background transparent, or apply a custom color.
/// Use [YPayBnplPreviewWidgetView.setBackgroundColor] for setting custom color.
enum YPayWidgetBackground {
  standard,
  transparent,
  custom,
}

/// Header options for the widget. You can choose standard view
/// or minified (without logo and title). Click handling only works
/// with the standard header.
enum YPayWidgetHeader {
  standard,
  minified,
}

/// Size style options for the widget. This affects the margins
/// between widget elements and the padding. [WidgetSize.MEDIUM] is used by default.
enum YPayWidgetSize {
  small,
  medium,
}
