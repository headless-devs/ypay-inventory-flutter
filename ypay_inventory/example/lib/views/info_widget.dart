import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';
import 'package:ypay_inventory_example/widgets/dropdowns/info_widget_dropdowns.dart';
import 'package:ypay_inventory_example/widgets/label.dart';

class InfoWidget extends StatelessWidget {
  final Controllers controllers;

  const InfoWidget({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: "Info виджет"),
        const SizedBox(height: 4),
        const InfoWidgetThemeDropdown(),
        const SizedBox(height: 4),
        const InfoWidgetTypeDropdown(),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return YPayInfoWidgetView(
              sum: controllers.selectedValues.amount,
              renderData: InfoWidgetRenderData(
                theme: controllers.selectedValues.infoWidgetTheme,
                types: controllers.selectedValues.infoWidgetTypes,
              ),
            );
          },
        )
      ],
    );
  }
}
