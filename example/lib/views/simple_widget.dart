import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';
import 'package:ypay_inventory_example/widgets/dropdowns/badges_dropdowns.dart';
import 'package:ypay_inventory_example/widgets/dropdowns/simple_widget_dropdowns.dart';
import 'package:ypay_inventory_example/widgets/label.dart';

class SimpleWidget extends StatelessWidget {
  final Controllers controllers;

  const SimpleWidget({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: "Simple виджет"),
        const SizedBox(height: 4),
        const SimpleWidgetThemeDropdown(),
        const SizedBox(height: 4),
        const SimpleWidgetTypeDropdown(),
        const SizedBox(height: 4),
        const SimpleWidgetStyleDropdown(),
        const CashbackBadgeVariantDropdown(),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return YPaySimpleWidgetView(
              sum: controllers.selectedValues.amount,
              renderData: SimpleWidgetRenderData(
                style: controllers.selectedValues.simpleWidgetStyle,
                theme: controllers.selectedValues.simpleWidgetTheme,
                types: controllers.selectedValues.simpleWidgetTypes,
              ),
            );
          },
        )
      ],
    );
  }
}
