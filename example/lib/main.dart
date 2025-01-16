import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ypay_inventory/ypay_inventory.dart';
import 'package:ypay_inventory_example/views/bnpl_widget.dart';
import 'package:ypay_inventory_example/views/cashback_badge.dart';
import 'package:ypay_inventory_example/views/info_widget.dart';
import 'package:ypay_inventory_example/views/simple_widget.dart';
import 'package:ypay_inventory_example/views/split_badge.dart';

import 'controllers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const YPayMainScreen(),
    );
  }
}

class YPayMainScreen extends StatefulWidget {
  const YPayMainScreen({super.key});

  @override
  State<YPayMainScreen> createState() => _YPayMainScreenState();
}

class _YPayMainScreenState extends State<YPayMainScreen> {
  final _ypayPlugin = YPayInventory.instance;

  Future<bool> _init() async {
    try {
      await _ypayPlugin.init(
          configuration: const YPayInventoryConfiguration(
        merchantId: 'merchantId',
        merchantName: 'merchantName',
        merchantUrl: 'merchantUrl',
      ));

      return true;
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(toolbarHeight: 0),
      body: FutureBuilder(
        future: _init(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const SizedBox();
          } else {
            return const YPayWidgetsPage();
          }
        },
      ),
    );
  }
}

class YPayWidgetsPage extends StatefulWidget {
  const YPayWidgetsPage({
    super.key,
  });

  @override
  State<YPayWidgetsPage> createState() => _YPayWidgetsPageState();
}

class _YPayWidgetsPageState extends State<YPayWidgetsPage> {
  final _controllers = Controllers();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controllers,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16) + const EdgeInsets.only(bottom: 60),
          child: Column(
            children: [
              CashbackBadge(controllers: _controllers),
              const SizedBox(height: 32),
              SplitBadge(controllers: _controllers),
              const SizedBox(height: 32),
              SimpleWidget(controllers: _controllers),
              const SizedBox(height: 32),
              InfoWidget(controllers: _controllers),
              const SizedBox(height: 32),
              BnplWidget(controllers: _controllers),
            ],
          ),
        ),
      ),
    );
  }
}
