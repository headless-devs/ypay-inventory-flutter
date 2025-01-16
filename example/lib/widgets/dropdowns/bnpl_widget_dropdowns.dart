import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';

class BnplWidgetBackgroundDropdown extends StatelessWidget {
  const BnplWidgetBackgroundDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Бэкграунд"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayWidgetBackground>(
              value: controllers.selectedValues.bnplBackground,
              items: const [
                DropdownMenuItem(
                  value: YPayWidgetBackground.standard,
                  child: Text(
                    "Стандартный",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetBackground.transparent,
                  child: Text(
                    "Прозрачный",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetBackground.custom,
                  child: Text(
                    "Кастомный",
                  ),
                ),
              ],
              onChanged: (background) => controllers.onBnplBackgroundChanged(background!),
            );
          },
        ),
      ],
    );
  }
}

class BnplWidgetHasCheckoutButtonRadioButton extends StatelessWidget {
  const BnplWidgetHasCheckoutButtonRadioButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Оформить"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return Checkbox(
              value: value.selectedValues.bnplHasCheckoutButton,
              tristate: false,
              onChanged: (toggle) => controllers.onBnplHasCheckoutButtonChanged(toggle!),
            );
          },
        ),
      ],
    );
  }
}

class BnplWidgetHasOutlineRadioButton extends StatelessWidget {
  const BnplWidgetHasOutlineRadioButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Обводка"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return Checkbox(
              value: value.selectedValues.bnplHasOutline,
              tristate: false,
              onChanged: (toggle) => controllers.onBnplHasOutlineChanged(toggle!),
            );
          },
        ),
      ],
    );
  }
}

class BnplWidgetHasPaddingRadioButton extends StatelessWidget {
  const BnplWidgetHasPaddingRadioButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Отступы"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return Checkbox(
              value: value.selectedValues.bnplHasPadding,
              tristate: false,
              onChanged: (toggle) => controllers.onBnplHasPaddingChanged(toggle!),
            );
          },
        ),
      ],
    );
  }
}

class BnplWidgetHeaderDropdown extends StatelessWidget {
  const BnplWidgetHeaderDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Хэдер"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayWidgetHeader>(
              value: controllers.selectedValues.bnplHeader,
              items: const [
                DropdownMenuItem(
                  value: YPayWidgetHeader.standard,
                  child: Text(
                    "Стандартный",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetHeader.minified,
                  child: Text(
                    "Уменьшенный",
                  ),
                ),
              ],
              onChanged: (header) => controllers.onBnplHeaderChanged(header!),
            );
          },
        ),
      ],
    );
  }
}

class BnplWidgetSizeDropdown extends StatelessWidget {
  const BnplWidgetSizeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Размер"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayWidgetSize>(
              value: controllers.selectedValues.bnplSize,
              items: const [
                DropdownMenuItem(
                  value: YPayWidgetSize.medium,
                  child: Text(
                    "Средний",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetSize.small,
                  child: Text(
                    "Маленький",
                  ),
                ),
              ],
              onChanged: (size) => controllers.onBnplSizeChanged(size!),
            );
          },
        ),
      ],
    );
  }
}

class BnplWidgetThemeDropdown extends StatelessWidget {
  const BnplWidgetThemeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Тема"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayWidgetTheme>(
              value: controllers.selectedValues.bnplTheme,
              items: const [
                DropdownMenuItem(
                  value: YPayWidgetTheme.system,
                  child: Text(
                    "Системная тема",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetTheme.light,
                  child: Text(
                    "Светлая тема",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetTheme.dark,
                  child: Text(
                    "Темная тема",
                  ),
                ),
              ],
              onChanged: (theme) => controllers.onBnplThemeChanged(theme!),
            );
          },
        ),
      ],
    );
  }
}
