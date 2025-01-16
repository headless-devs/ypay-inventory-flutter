import 'dart:io';

/// Visual parameters used to configure YPayBadgeView
///
/// See variants in https://pay.yandex.ru/docs/ru/custom/android-sdk/inventory/badges
sealed class BadgeRenderData {
  /// BadgeRenderData
  const BadgeRenderData();

  /// SplitBadgeRenderData
  static SplitBadgeRenderData split({
    YPayBadgeTheme theme = YPayBadgeTheme.system,
    YPayBadgeAlign align = YPayBadgeAlign.left,
    SplitBadgeColor color = SplitBadgeColor.primary,
    SplitBadgeVariant variant = SplitBadgeVariant.detailed,
  }) =>
      SplitBadgeRenderData(
        theme: theme,
        align: align,
        color: color,
        variant: variant,
      );

  /// CashbackBadgeRenderData
  static CashbackBadgeRenderData cashback({
    YPayBadgeTheme theme = YPayBadgeTheme.system,
    YPayBadgeAlign align = YPayBadgeAlign.left,
    CashbackBadgeColor color = CashbackBadgeColor.primary,
    CashbackBadgeVariant variant = CashbackBadgeVariant.detailed,
  }) =>
      CashbackBadgeRenderData(
        theme: theme,
        align: align,
        color: color,
        variant: variant,
      );

  /// Параметры для создания виджета
  Map<String, dynamic> creationParams();
}

/// Render data to configure split badge
class SplitBadgeRenderData extends BadgeRenderData {
  /// SplitBadgeRenderData
  const SplitBadgeRenderData({
    this.theme = YPayBadgeTheme.system,
    this.align = YPayBadgeAlign.left,
    this.color = SplitBadgeColor.primary,
    this.variant = SplitBadgeVariant.detailed,
  });

  final YPayBadgeTheme theme;
  final YPayBadgeAlign align;
  final SplitBadgeColor color;
  final SplitBadgeVariant variant;

  @override
  Map<String, dynamic> creationParams() => {
        'theme': theme.name,
        'align': align.name,
        'color': color.name,
        'variant': variant.name,
        'style': 'split',
      };
}

/// Render data to configure cashback badge
class CashbackBadgeRenderData extends BadgeRenderData {
  /// CashbackBadgeRenderData
  const CashbackBadgeRenderData({
    this.theme = YPayBadgeTheme.system,
    this.align = YPayBadgeAlign.left,
    this.color = CashbackBadgeColor.primary,
    this.variant = CashbackBadgeVariant.detailed,
  });

  final YPayBadgeTheme theme;
  final YPayBadgeAlign align;
  final CashbackBadgeColor color;
  final CashbackBadgeVariant variant;

  @override
  Map<String, dynamic> creationParams() => {
        'theme': theme.name,
        'align': align.name,
        'color': color.name,
        'variant': variant.variant,
        'style': 'cashback',
      };
}

/// Theme that will be used to configure the badge
enum YPayBadgeTheme {
  light,
  dark,
  system,
}

/// Align that will be used to configure the badge
enum YPayBadgeAlign {
  left,
  center,
  right,
}

/// Variant of split that will be used to configure the badge
enum SplitBadgeVariant {
  /// Badge will have long split label
  detailed,

  /// Badge will have short split label
  simple,
}

/// Color of split that will be used to configure the badge
enum SplitBadgeColor {
  primary,
  green,
  grey,
  transparent,
}

/// Cashback badge formatting variant
enum CashbackBadgeVariant {
  /// Badge will have the number and the title
  detailed,

  /// Badge will have a short label with the number only
  simple;

  String get variant {
    switch (this) {
      case CashbackBadgeVariant.detailed:
        return Platform.isIOS ? 'default' : 'detailed';
      case CashbackBadgeVariant.simple:
        return Platform.isIOS ? 'compact' : 'simple';
    }
  }
}

/// Color that will be used to create cashback badge
enum CashbackBadgeColor {
  primary,
  grey,
  transparent,
}
