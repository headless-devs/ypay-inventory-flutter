// import 'package:example/controllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/controllers.dart';

class CashbackAlignDropdown extends StatelessWidget {
  const CashbackAlignDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Выравнивание"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayBadgeAlign>(
              value: controllers.selectedValues.cashbackAlign,
              items: const [
                DropdownMenuItem(
                  value: YPayBadgeAlign.left,
                  child: Text(
                    "По левому краю",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayBadgeAlign.center,
                  child: Text(
                    "По центру",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayBadgeAlign.right,
                  child: Text(
                    "По правому краю",
                  ),
                ),
              ],
              onChanged: (align) => controllers.onCashbackAlignChanged(align!),
            );
          },
        ),
      ],
    );
  }
}

class CashbackBadgeColorDropdown extends StatelessWidget {
  const CashbackBadgeColorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Цвет"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<CashbackBadgeColor>(
              value: controllers.selectedValues.cashbackBadgeColor,
              items: const [
                DropdownMenuItem(
                  value: CashbackBadgeColor.grey,
                  child: Text(
                    "Серый",
                  ),
                ),
                DropdownMenuItem(
                  value: CashbackBadgeColor.primary,
                  child: Text(
                    "Стандартный",
                  ),
                ),
                DropdownMenuItem(
                  value: CashbackBadgeColor.transparent,
                  child: Text(
                    "Прозрачный",
                  ),
                ),
              ],
              onChanged: (color) => controllers.onCashbackBadgeColorChanged(color!),
            );
          },
        ),
      ],
    );
  }
}

class CashbackBadgeVariantDropdown extends StatelessWidget {
  const CashbackBadgeVariantDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Вариант"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<CashbackBadgeVariant>(
              value: controllers.selectedValues.cashbackBadgeVariant,
              items: const [
                DropdownMenuItem(
                  value: CashbackBadgeVariant.simple,
                  child: Text(
                    "Простой",
                  ),
                ),
                DropdownMenuItem(
                  value: CashbackBadgeVariant.detailed,
                  child: Text(
                    "Детальный",
                  ),
                ),
              ],
              onChanged: (variant) => controllers.onCashbackBadgeVariantChanged(variant!),
            );
          },
        ),
      ],
    );
  }
}

class SplitAlignDropdown extends StatelessWidget {
  const SplitAlignDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Выравнивание"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<YPayBadgeAlign>(
              value: controllers.selectedValues.splitAlign,
              items: const [
                DropdownMenuItem(
                  value: YPayBadgeAlign.left,
                  child: Text(
                    "По левому краю",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayBadgeAlign.center,
                  child: Text(
                    "По центру",
                  ),
                ),
                DropdownMenuItem(
                  value: YPayBadgeAlign.right,
                  child: Text(
                    "По правому краю",
                  ),
                ),
              ],
              onChanged: (align) => controllers.onSplitAlignChanged(align!),
            );
          },
        ),
      ],
    );
  }
}

class SplitBadgeColorDropdown extends StatelessWidget {
  const SplitBadgeColorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Цвет"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<SplitBadgeColor>(
              value: controllers.selectedValues.splitBadgeColor,
              items: const [
                DropdownMenuItem(
                  value: SplitBadgeColor.grey,
                  child: Text(
                    "Серый",
                  ),
                ),
                DropdownMenuItem(
                  value: SplitBadgeColor.primary,
                  child: Text(
                    "Стандартный",
                  ),
                ),
                DropdownMenuItem(
                  value: SplitBadgeColor.transparent,
                  child: Text(
                    "Прозрачный",
                  ),
                ),
                DropdownMenuItem(
                  value: SplitBadgeColor.green,
                  child: Text(
                    "Зеленый",
                  ),
                ),
              ],
              onChanged: (color) => controllers.onSplitBadgeColorChanged(color!),
            );
          },
        ),
      ],
    );
  }
}

class SplitBadgeVariantDropdown extends StatelessWidget {
  const SplitBadgeVariantDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final controllers = Provider.of<Controllers>(context, listen: true);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Вариант"),
        Consumer<Controllers>(
          builder: (context, value, child) {
            return DropdownButton<SplitBadgeVariant>(
              value: controllers.selectedValues.splitBadgeVariant,
              items: const [
                DropdownMenuItem(
                  value: SplitBadgeVariant.simple,
                  child: Text(
                    "Простой",
                  ),
                ),
                DropdownMenuItem(
                  value: SplitBadgeVariant.detailed,
                  child: Text(
                    "Детальный",
                  ),
                ),
              ],
              onChanged: (variant) => controllers.onSplitBadgeVariantChanged(variant!),
            );
          },
        ),
      ],
    );
  }
}
