import 'package:flutter/material.dart';
import 'package:ypay_inventory/ypay_inventory.dart';

class Controllers with ChangeNotifier {
  final selectedValues = SelectedValues();

  final sumController = TextEditingController();

  void onThemeChanged(YPayBadgeTheme theme) {
    selectedValues._theme = theme;
    notifyListeners();
  }

  void onCashbackAlignChanged(YPayBadgeAlign align) {
    selectedValues._cashbackAlign = align;
    notifyListeners();
  }

  void onSplitAlignChanged(YPayBadgeAlign align) {
    selectedValues._splitAlign = align;
    notifyListeners();
  }

  void onCashbackBadgeColorChanged(CashbackBadgeColor color) {
    selectedValues._cashbackBadgeColor = color;
    notifyListeners();
  }

  void onCashbackBadgeVariantChanged(CashbackBadgeVariant variant) {
    selectedValues._cashbackBadgeVariant = variant;
    notifyListeners();
  }

  void onSplitBadgeColorChanged(SplitBadgeColor color) {
    selectedValues._splitBadgeColor = color;
    notifyListeners();
  }

  void onSplitBadgeVariantChanged(SplitBadgeVariant variant) {
    selectedValues._splitBadgeVariant = variant;
    notifyListeners();
  }

  void onSimpleWidgetTypeChanged(SimpleWidgetTheme type) {
    switch (type) {
      case SimpleWidgetTheme.split:
        selectedValues._simpleWidgetTypes = {YPayWidgetType.split};
      case SimpleWidgetTheme.cashback:
        selectedValues._simpleWidgetTypes = {YPayWidgetType.cashback};
      case SimpleWidgetTheme.both:
        selectedValues._simpleWidgetTypes = {YPayWidgetType.cashback, YPayWidgetType.split};
    }

    notifyListeners();
  }

  void onSimpleWidgetThemeChanged(YPayWidgetTheme theme) {
    selectedValues._simpleWidgetTheme = theme;
    notifyListeners();
  }

  void onSimpleWidgetStyleChanged(YPayWidgetStyle style) {
    selectedValues._simpleWidgetStyle = style;
    notifyListeners();
  }

  void onInfoWidgetTypeChanged(SimpleWidgetTheme type) {
    switch (type) {
      case SimpleWidgetTheme.split:
        selectedValues._infoWidgetTypes = {YPayWidgetType.split};
      case SimpleWidgetTheme.cashback:
        selectedValues._infoWidgetTypes = {YPayWidgetType.cashback};
      case SimpleWidgetTheme.both:
        selectedValues._infoWidgetTypes = {YPayWidgetType.cashback, YPayWidgetType.split};
    }

    notifyListeners();
  }

  void onInfoWidgetThemeChanged(YPayWidgetTheme theme) {
    selectedValues._infoWidgetTheme = theme;
    notifyListeners();
  }

  void onBnplBackgroundChanged(YPayWidgetBackground background) {
    selectedValues._bnplBackground = background;
    if (background == YPayWidgetBackground.custom) {
      selectedValues._bnplBackgroundColor = Colors.orange;
    } else {
      selectedValues._bnplBackgroundColor = null;
    }
    notifyListeners();
  }

  void onBnplBackgroundColorChanged(Color? color) {
    selectedValues._bnplBackgroundColor = color;
    notifyListeners();
  }

  void onBnplHasCheckoutButtonChanged(bool toggle) {
    selectedValues._bnplHasCheckoutButton = toggle;
    notifyListeners();
  }

  void onBnplHasOutlineChanged(bool toggle) {
    selectedValues._bnplHasOutline = toggle;
    notifyListeners();
  }

  void onBnplHasPaddingChanged(bool toggle) {
    selectedValues._bnplHasPadding = toggle;
    notifyListeners();
  }

  void onBnplHeaderChanged(YPayWidgetHeader header) {
    selectedValues._bnplHeader = header;
    notifyListeners();
  }

  void onBnplRadiusChanged(double radius) {
    selectedValues._bnplRadius = radius;
    notifyListeners();
  }

  void onBnplSizeChanged(YPayWidgetSize size) {
    selectedValues._bnplSize = size;
    notifyListeners();
  }

  void onBnplThemeChanged(YPayWidgetTheme theme) {
    selectedValues._bnplTheme = theme;
    notifyListeners();
  }
}

class SelectedValues {
  YPayBadgeTheme _theme = YPayBadgeTheme.system;
  final double _amount = 1000000;

  /// CASHBACK BADGE/////////////////////////////////////////////////////////

  YPayBadgeAlign _cashbackAlign = YPayBadgeAlign.left;
  CashbackBadgeColor _cashbackBadgeColor = CashbackBadgeColor.primary;
  CashbackBadgeVariant _cashbackBadgeVariant = CashbackBadgeVariant.detailed;

  YPayBadgeAlign get cashbackAlign => _cashbackAlign;
  CashbackBadgeColor get cashbackBadgeColor => _cashbackBadgeColor;
  CashbackBadgeVariant get cashbackBadgeVariant => _cashbackBadgeVariant;

  ///////////////////////////////////////////////////////////////////////////

  /// SPLIT BADGE //////////////////////////////////////////////////

  YPayBadgeAlign _splitAlign = YPayBadgeAlign.left;
  SplitBadgeColor _splitBadgeColor = SplitBadgeColor.primary;
  SplitBadgeVariant _splitBadgeVariant = SplitBadgeVariant.detailed;

  YPayBadgeAlign get splitAlign => _splitAlign;
  SplitBadgeColor get splitBadgeColor => _splitBadgeColor;
  SplitBadgeVariant get splitBadgeVariant => _splitBadgeVariant;

  //////////////////////////////////////////////////////////////////

  /// SIMPLE WIDGET /////////////////////////////////////////////////////

  Set<YPayWidgetType> _simpleWidgetTypes = {
    YPayWidgetType.cashback,
    YPayWidgetType.split,
  };

  final SimpleWidgetTheme _simpleWidgetTypeEnum = SimpleWidgetTheme.both;
  SimpleWidgetTheme get simpleWidgetTypeEnum => _simpleWidgetTypeEnum;

  YPayWidgetTheme _simpleWidgetTheme = YPayWidgetTheme.system;
  YPayWidgetStyle _simpleWidgetStyle = YPayWidgetStyle.solid;

  Set<YPayWidgetType> get simpleWidgetTypes => _simpleWidgetTypes;
  YPayWidgetTheme get simpleWidgetTheme => _simpleWidgetTheme;
  YPayWidgetStyle get simpleWidgetStyle => _simpleWidgetStyle;

  ///////////////////////////////////////////////////////////////////////

  /// INFO WIDGET /////////////////////////////////////////////////////

  Set<YPayWidgetType> _infoWidgetTypes = {
    YPayWidgetType.cashback,
    YPayWidgetType.split,
  };

  final SimpleWidgetTheme _infoWidgetTypeEnum = SimpleWidgetTheme.both;

  SimpleWidgetTheme get infoWidgetTypeEnum => _infoWidgetTypeEnum;

  YPayWidgetTheme _infoWidgetTheme = YPayWidgetTheme.system;

  Set<YPayWidgetType> get infoWidgetTypes => _infoWidgetTypes;
  YPayWidgetTheme get infoWidgetTheme => _infoWidgetTheme;

  /////////////////////////////////////////////////////////////////////

  /// BNPL WIDGET /////////////////////////////////////////////////////

  YPayWidgetBackground _bnplBackground = YPayWidgetBackground.standard;
  Color? _bnplBackgroundColor;
  bool _bnplHasCheckoutButton = false;
  bool _bnplHasOutline = true;
  bool _bnplHasPadding = true;
  YPayWidgetHeader _bnplHeader = YPayWidgetHeader.standard;
  double _bnplRadius = 30;
  YPayWidgetSize _bnplSize = YPayWidgetSize.medium;
  YPayWidgetTheme _bnplTheme = YPayWidgetTheme.system;

  YPayWidgetBackground get bnplBackground => _bnplBackground;
  Color? get bnplBackgroundColor => _bnplBackgroundColor;
  bool get bnplHasCheckoutButton => _bnplHasCheckoutButton;
  bool get bnplHasOutline => _bnplHasOutline;
  bool get bnplHasPadding => _bnplHasPadding;
  YPayWidgetHeader get bnplHeader => _bnplHeader;
  double get bnplRadius => _bnplRadius;
  YPayWidgetSize get bnplSize => _bnplSize;
  YPayWidgetTheme get bnplTheme => _bnplTheme;

  /////////////////////////////////////////////////////////////////////

  YPayBadgeTheme get theme => _theme;
  double get amount => _amount;
}

enum SimpleWidgetTheme {
  split,
  cashback,
  both;
}
