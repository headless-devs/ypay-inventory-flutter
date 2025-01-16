import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';

class InfoWidgetThemeDropdown extends StatelessWidget {
  const InfoWidgetThemeDropdown({super.key});

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
              value: controllers.selectedValues.infoWidgetTheme,
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
              onChanged: (theme) => controllers.onInfoWidgetThemeChanged(theme!),
            );
          },
        ),
      ],
    );
  }
}

class InfoWidgetTypeDropdown extends StatelessWidget {
  const InfoWidgetTypeDropdown({super.key});

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
              value: controllers.selectedValues.infoWidgetTypeEnum,
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
              onChanged: (type) => controllers.onInfoWidgetTypeChanged(type!),
            );
          },
        ),
      ],
    );
  }
}
