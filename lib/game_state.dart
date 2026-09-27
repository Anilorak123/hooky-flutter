import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Item {
  final String name;
  final int baseTime; // seconds
  final int basePrice;

  const Item({required this.name, required this.baseTime, required this.basePrice});
}

const List<Item> items = [
  Item(name: 'Beanie', baseTime: 10, basePrice: 30),
  Item(name: 'Scarf', baseTime: 20, basePrice: 50),
  Item(name: 'Socks', baseTime: 15, basePrice: 40),
];

class CraftingSlot {
  final Item item;
  final DateTime startTime;
  final int duration;

  CraftingSlot({
    required this.item,
    required this.startTime,
    required this.duration,
  });

  double get progress {
    final elapsed = DateTime.now().difference(startTime).inSeconds;
    return (elapsed / duration).clamp(0.0, 1.0);
  }

  bool get isFinished => progress >= 1.0;
}

class GameState extends ChangeNotifier {
  double coins = 0;
  double coinsPerSecond = 0;
  List<String> inventory = [];
  CraftingSlot? craftingSlot;
  Timer? _timer;

  GameState() {
    _load();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      coins += coinsPerSecond;
      _checkCrafting();
      notifyListeners();
    });
  }

  void _checkCrafting() {
    if (craftingSlot != null && craftingSlot!.isFinished) {
      inventory.add(craftingSlot!.item.name);
      craftingSlot = null;
      _save();
    }
  }

  bool startCrafting(Item item) {
    if (craftingSlot != null) return false;
    craftingSlot = CraftingSlot(
      item: item,
      startTime: DateTime.now(),
      duration: item.baseTime,
    );
    notifyListeners();
    return true;
  }

  void sellAll() {
    int total = 0;
    for (final itemName in inventory) {
      final item = items.firstWhere((i) => i.name == itemName);
      total += item.basePrice;
    }
    coins += total;
    inventory.clear();
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('coins', coins);
    await prefs.setStringList('inventory', inventory);
    await prefs.setInt('closeTime', DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    coins = prefs.getDouble('coins') ?? 0;
    inventory = prefs.getStringList('inventory') ?? [];

    // Offline earnings
    final closeTime = prefs.getInt('closeTime');
    if (closeTime != null && coinsPerSecond > 0) {
      final secondsAway = (DateTime.now().millisecondsSinceEpoch - closeTime) ~/ 1000;
      final capped = secondsAway.clamp(0, 8 * 3600);
      coins += capped * coinsPerSecond;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}