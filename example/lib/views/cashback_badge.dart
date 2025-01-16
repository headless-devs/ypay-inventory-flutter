import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';
import 'package:ypay_inventory_example/widgets/dropdowns/badges_dropdowns.dart';
import 'package:ypay_inventory_example/widgets/label.dart';

class CashbackBadge extends StatelessWidget {
  final Controllers controllers;

  const CashbackBadge({
    super.key,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Label(label: "Кэшбэк бейдж"),
        const SizedBox(height: 4),
        const CashbackAlignDropdown(),
        const SizedBox(height: 4),
        const CashbackBadgeColorDropdown(),
        const SizedBox(height: 4),
        const CashbackBadgeVariantDropdown(),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return YPayBadge(
              sum: double.tryParse(controllers.sumController.text) ?? 1000000,
              width: 200,
              height: 200,
              renderData: CashbackBadgeRenderData(
                theme: value.selectedValues.theme,
                align: value.selectedValues.cashbackAlign,
                color: value.selectedValues.cashbackBadgeColor,
                variant: value.selectedValues.cashbackBadgeVariant,
              ),
            );
          },
        )
      ],
    );
  }
}
