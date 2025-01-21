import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';
import 'package:ypay_inventory_example/widgets/dropdowns/badges_dropdowns.dart';
import 'package:ypay_inventory_example/widgets/label.dart';

class SplitBadge extends StatelessWidget {
  final Controllers controllers;

  const SplitBadge({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: "Сплит бейдж"),
        const SizedBox(height: 4),
        const SplitAlignDropdown(),
        const SizedBox(height: 4),
        const SplitBadgeColorDropdown(),
        const SizedBox(height: 4),
        const SplitBadgeVariantDropdown(),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return YPayBadge(
              sum: double.tryParse(controllers.sumController.text) ?? 200000,
              width: 200,
              renderData: SplitBadgeRenderData(
                theme: value.selectedValues.theme,
                align: value.selectedValues.splitAlign,
                color: value.selectedValues.splitBadgeColor,
                variant: value.selectedValues.splitBadgeVariant,
              ),
            );
          },
        )
      ],
    );
  }
}
