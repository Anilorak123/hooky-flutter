import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Item {
  final String name;
  final int baseTime;
  final int basePrice;
  final int unlockLevel;
  final String category;

  const Item({
    required this.name,
    required this.baseTime,
    required this.basePrice,
    this.unlockLevel = 1,
    required this.category,
  });
}

const List<Item> items = [
  // Accessories - available from start
  Item(name: 'Beanie', baseTime: 10, basePrice: 30, unlockLevel: 1, category: 'Accessories'),
  Item(name: 'Scrunchie', baseTime: 8, basePrice: 20, unlockLevel: 1, category: 'Accessories'),
  Item(name: 'Scarf', baseTime: 20, basePrice: 50, unlockLevel: 1, category: 'Accessories'),
  Item(name: 'Socks', baseTime: 15, basePrice: 40, unlockLevel: 2, category: 'Accessories'),
  Item(name: 'Fingerless Gloves', baseTime: 25, basePrice: 65, unlockLevel: 2, category: 'Accessories'),
  // Home decor - unlock level 3
  Item(name: 'Pot Holder', baseTime: 30, basePrice: 80, unlockLevel: 3, category: 'Home Decor'),
  Item(name: 'Coaster Set', baseTime: 35, basePrice: 90, unlockLevel: 3, category: 'Home Decor'),
  Item(name: 'Pillow Cover', baseTime: 60, basePrice: 150, unlockLevel: 4, category: 'Home Decor'),
  // Amigurumi - unlock level 5
  Item(name: 'Cactus Plushie', baseTime: 80, basePrice: 180, unlockLevel: 5, category: 'Amigurumi'),
  Item(name: 'Bunny Plushie', baseTime: 90, basePrice: 200, unlockLevel: 5, category: 'Amigurumi'),
  Item(name: 'Bear Plushie', baseTime: 120, basePrice: 250, unlockLevel: 6, category: 'Amigurumi'),
  // Clothing - unlock level 7
  Item(name: 'Baby Booties', baseTime: 45, basePrice: 120, unlockLevel: 7, category: 'Clothing'),
  Item(name: 'Crop Top', baseTime: 180, basePrice: 400, unlockLevel: 8, category: 'Clothing'),
  Item(name: 'Cardigan', baseTime: 300, basePrice: 700, unlockLevel: 9, category: 'Clothing'),
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

class Yarn {
  final String id;
  final String name;
  final String description;
  final double priceMultiplier;
  final int cost;
  final Color color;

  const Yarn({
    required this.id,
    required this.name,
    required this.description,
    required this.priceMultiplier,
    required this.cost,
    required this.color,
  });
}

const List<Yarn> yarns = [
  Yarn(
    id: 'acrylic',
    name: 'Acrylic',
    description: 'Basic yarn, good for beginners',
    priceMultiplier: 1.0,
    cost: 0,
    color: Color(0xFFAAAAAA),
  ),
  Yarn(
    id: 'cotton',
    name: 'Cotton',
    description: 'Soft and breathable',
    priceMultiplier: 1.5,
    cost: 300,
    color: Color(0xFFF5CBA7),
  ),
  Yarn(
    id: 'wool',
    name: 'Wool',
    description: 'Warm and cozy',
    priceMultiplier: 2.5,
    cost: 1000,
    color: Color(0xFFC39BD3),
  ),
  Yarn(
    id: 'alpaca',
    name: 'Alpaca',
    description: 'Incredibly soft luxury yarn',
    priceMultiplier: 4.0,
    cost: 5000,
    color: Color(0xFF85C1E9),
  ),
  Yarn(
    id: 'silk',
    name: 'Silk Blend',
    description: 'The finest yarn available',
    priceMultiplier: 8.0,
    cost: 20000,
    color: Color(0xFFF9E79F),
  ),
];

class Level {
  final int level;
  final int xpRequired;
  final int coinReward;
  final String title;

  const Level({
    required this.level,
    required this.xpRequired,
    required this.coinReward,
    required this.title,
  });
}

const List<Level> levels = [
  Level(level: 1, xpRequired: 0, coinReward: 0, title: 'Beginner Crocheter'),
  Level(level: 2, xpRequired: 100, coinReward: 50, title: 'Yarn Enthusiast'),
  Level(level: 3, xpRequired: 300, coinReward: 150, title: 'Hook Master'),
  Level(level: 4, xpRequired: 600, coinReward: 400, title: 'Craft Artist'),
  Level(level: 5, xpRequired: 1000, coinReward: 800, title: 'Wool Wizard'),
  Level(level: 6, xpRequired: 2000, coinReward: 2000, title: 'Amigurumi Expert'),
  Level(level: 7, xpRequired: 4000, coinReward: 5000, title: 'Crochet Entrepreneur'),
  Level(level: 8, xpRequired: 8000, coinReward: 12000, title: 'Yarn Tycoon'),
  Level(level: 9, xpRequired: 15000, coinReward: 30000, title: 'Crochet Legend'),
  Level(level: 10, xpRequired: 30000, coinReward: 100000, title: 'Grand Master'),
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
  String currentYarnId = 'acrylic';
  Set<String> unlockedYarns = {'acrylic'};
  int xp = 0;
  int level = 1;
  String? levelUpMessage;

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
      final price = (item.basePrice * getYarnMultiplier()).toInt();
      total += price;
      addXp(item.basePrice ~/ 10);
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

bool buyYarn(Yarn yarn) {
  if (unlockedYarns.contains(yarn.id)) {
    currentYarnId = yarn.id;
    notifyListeners();
    return true;
  }
  if (coins >= yarn.cost) {
    coins -= yarn.cost;
    unlockedYarns.add(yarn.id);
    currentYarnId = yarn.id;
    notifyListeners();
    _save();
    return true;
  }
  return false;
}

double getYarnMultiplier() {
  return yarns.firstWhere((y) => y.id == currentYarnId).priceMultiplier;
}

Yarn getCurrentYarn() {
  return yarns.firstWhere((y) => y.id == currentYarnId);
}

void _updateCoinsPerSecond() {
  coinsPerSecond = 0;
  for (final worker in workers) {
    final count = workerCounts[worker.id] ?? 0;
    coinsPerSecond += worker.coinsPerSecond * count;
  }
}

void addXp(int amount) {
  xp += amount;
  _checkLevelUp();
  notifyListeners();
}

void _checkLevelUp() {
  for (final levelData in levels) {
    if (levelData.level == level + 1 && xp >= levelData.xpRequired) {
      level++;
      coins += levelData.coinReward;
      levelUpMessage =
          'Level ${levelData.level}!\n${levelData.title}\n+${levelData.coinReward} coins!';
      _save();
      break;
    }
  }
}

Level getCurrentLevel() => levels.firstWhere((l) => l.level == level);

Level? getNextLevel() {
  try {
    return levels.firstWhere((l) => l.level == level + 1);
  } catch (_) {
    return null;
  }
}

double getXpProgress() {
  final current = getCurrentLevel();
  final next = getNextLevel();
  if (next == null) return 1.0;
  final currentXp = xp - current.xpRequired;
  final needed = next.xpRequired - current.xpRequired;
  return (currentXp / needed).clamp(0.0, 1.0);
}



  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('coins', coins);
    await prefs.setStringList('inventory', inventory);
    await prefs.setInt('closeTime', DateTime.now().millisecondsSinceEpoch);
    await prefs.setString('currentYarn', currentYarnId);
    await prefs.setStringList('unlockedYarns', unlockedYarns.toList());
    await prefs.setInt('xp', xp);
    await prefs.setInt('level', level);
    await prefs.setString('workers', workerCounts.entries
    .map((e) => '${e.key}:${e.value}')
    .join(','));
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    coins = prefs.getDouble('coins') ?? 0;
    inventory = prefs.getStringList('inventory') ?? [];
    currentYarnId = prefs.getString('currentYarn') ?? 'acrylic';
    unlockedYarns = (prefs.getStringList('unlockedYarns') ?? ['acrylic']).toSet();
    xp = prefs.getInt('xp') ?? 0;
    level = prefs.getInt('level') ?? 1;
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