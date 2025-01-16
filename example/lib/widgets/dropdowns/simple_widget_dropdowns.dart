import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';

class SimpleWidgetThemeDropdown extends StatelessWidget {
  const SimpleWidgetThemeDropdown({super.key});

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
              value: controllers.selectedValues.simpleWidgetTheme,
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
              onChanged: (theme) => controllers.onSimpleWidgetThemeChanged(theme!),
            );
          },
        ),
      ],
    );
  }
}

class SimpleWidgetTypeDropdown extends StatelessWidget {
  const SimpleWidgetTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Тип"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<SimpleWidgetTheme>(
              value: controllers.selectedValues.simpleWidgetTypeEnum,
              items: const [
                DropdownMenuItem(
                  value: SimpleWidgetTheme.cashback,
                  child: Text(
                    "Только кэшбэк",
                  ),
                ),
                DropdownMenuItem(
                  value: SimpleWidgetTheme.split,
                  child: Text(
                    "Только сплит",
                  ),
                ),
                DropdownMenuItem(
                  value: SimpleWidgetTheme.both,
                  child: Text(
                    "Кэшбэк и сплит",
                  ),
                ),
              ],
              onChanged: (type) => controllers.onSimpleWidgetTypeChanged(type!),
            );
          },
        ),
      ],
    );
  }
}

class SimpleWidgetStyleDropdown extends StatelessWidget {
  const SimpleWidgetStyleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Стиль"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayWidgetStyle>(
              value: controllers.selectedValues.simpleWidgetStyle,
              items: const [
                DropdownMenuItem(
                  value: YPayWidgetStyle.solid,
                  child: Text(
                    "С заливкой",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayWidgetStyle.transparent,
                  child: Text(
                    "Прозрачный",
                  ),
                ),
              ],
              onChanged: (style) => controllers.onSimpleWidgetStyleChanged(style!),
            );
          },
        ),
      ],
    );
  }
}
