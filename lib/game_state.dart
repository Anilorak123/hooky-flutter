import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: unused_import

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

class Worker {
  final String id;
  final String name;
  final String description;
  final double coinsPerSecond;
  final int baseCost;

  const Worker({
    required this.id,
    required this.name,
    required this.description,
    required this.coinsPerSecond,
    required this.baseCost,
  });

  int costForCount(int count) => (baseCost * pow(1.15, count)).toInt();
}

const List<Worker> workers = [
  Worker(
    id: 'beanie_worker',
    name: 'Beanie Crocheter',
    description: 'Automatically crafts beanies',
    coinsPerSecond: 2,
    baseCost: 500,
  ),
  Worker(
    id: 'scarf_worker',
    name: 'Scarf Crocheter',
    description: 'Automatically crafts scarves',
    coinsPerSecond: 5,
    baseCost: 1500,
  ),
  Worker(
    id: 'socks_worker',
    name: 'Socks Crocheter',
    description: 'Automatically crafts socks',
    coinsPerSecond: 10,
    baseCost: 4000,
  ),
  Worker(
    id: 'amigurumi_artist',
    name: 'Amigurumi Artist',
    description: 'Makes cute plushies',
    coinsPerSecond: 25,
    baseCost: 12000,
  ),
  Worker(
    id: 'workshop_manager',
    name: 'Workshop Manager',
    description: 'Manages the whole workshop',
    coinsPerSecond: 75,
    baseCost: 40000,
  ),
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
  Map<String, int> workerCounts = {};

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

bool buyWorker(Worker worker) {
  final count = workerCounts[worker.id] ?? 0;
  final cost = worker.costForCount(count);
  if (coins >= cost) {
    coins -= cost;
    workerCounts[worker.id] = count + 1;
    _updateCoinsPerSecond();
    notifyListeners();
    _save();
    return true;
  }
  return false;
}

void _updateCoinsPerSecond() {
  coinsPerSecond = 0;
  for (final worker in workers) {
    final count = workerCounts[worker.id] ?? 0;
    coinsPerSecond += worker.coinsPerSecond * count;
  }
}

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('coins', coins);
    await prefs.setStringList('inventory', inventory);
    await prefs.setInt('closeTime', DateTime.now().millisecondsSinceEpoch);
    await prefs.setString('workers', workerCounts.entries
    .map((e) => '${e.key}:${e.value}')
    .join(','));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    coins = prefs.getDouble('coins') ?? 0;
    inventory = prefs.getStringList('inventory') ?? [];
    final workersStr = prefs.getString('workers') ?? '';
if (workersStr.isNotEmpty) {
  for (final entry in workersStr.split(',')) {
    final parts = entry.split(':');
    if (parts.length == 2) {
      workerCounts[parts[0]] = int.tryParse(parts[1]) ?? 0;
    }
  }
}
_updateCoinsPerSecond();

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