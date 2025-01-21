import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';
import 'package:ypay_inventory_example/widgets/dropdowns/bnpl_widget_dropdowns.dart';
import 'package:ypay_inventory_example/widgets/label.dart';

class BnplWidget extends StatelessWidget {
  final Controllers controllers;

  const BnplWidget({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: "BNPL виджет"),
        const SizedBox(height: 4),
        const BnplWidgetBackgroundDropdown(),
        const SizedBox(height: 4),
        const BnplWidgetHasCheckoutButtonRadioButton(),
        const SizedBox(height: 4),
        const BnplWidgetHasOutlineRadioButton(),
        const SizedBox(height: 4),
        const BnplWidgetHasPaddingRadioButton(),
        const SizedBox(height: 4),
        const BnplWidgetHeaderDropdown(),
        const SizedBox(height: 4),
        const BnplWidgetSizeDropdown(),
        const SizedBox(height: 4),
        const BnplWidgetThemeDropdown(),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return YPayBnplPreviewWidgetView(
              sum: controllers.selectedValues.amount,
              renderData: BnplPreviewWidgetRenderData(
                background: controllers.selectedValues.bnplBackground,
                backgroundColor: controllers.selectedValues.bnplBackgroundColor,
                hasCheckoutButton: controllers.selectedValues.bnplHasCheckoutButton,
                hasOutline: controllers.selectedValues.bnplHasOutline,
                hasPadding: controllers.selectedValues.bnplHasPadding,
                header: controllers.selectedValues.bnplHeader,
                radius: controllers.selectedValues.bnplRadius,
                size: controllers.selectedValues.bnplSize,
                theme: controllers.selectedValues.bnplTheme,
              ),
            );
          },
        )
      ],
    );
  }
}
