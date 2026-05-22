import 'package:flutter/foundation.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';

class RobotLoadStore {
  RobotLoadStore._();

  static final RobotLoadStore instance = RobotLoadStore._();

  final ValueNotifier<Map<String, List<LoadBoardItem>>> itemsByRobot =
  ValueNotifier<Map<String, List<LoadBoardItem>>>({
    'R-01': [
      LoadBoardItem(
        id: 'r01-1',
        robotId: 'R-01',
        zone: '1구역',
        building: '101',
        unit: '1104',
        createdAt: DateTime.now(),
        status: LoadItemStatus.loaded,
      ),
      LoadBoardItem(
        id: 'r01-2',
        robotId: 'R-01',
        zone: '2구역',
        building: '102',
        unit: '804',
        createdAt: DateTime.now(),
        status: LoadItemStatus.loaded,
      ),
    ],
    'R-02': [
      LoadBoardItem(
        id: 'r02-1',
        robotId: 'R-02',
        zone: '3구역',
        building: '101',
        unit: '1203',
        createdAt: DateTime.now(),
        status: LoadItemStatus.loaded,
      ),
    ],
    'R-03': [],
  });

  List<LoadBoardItem> getItems(String robotId) {
    return List.unmodifiable(itemsByRobot.value[robotId] ?? const []);
  }

  int countForRobot(String robotId) {
    return getItems(robotId).length;
  }

  Map<String, List<LoadBoardItem>> groupedItems(String robotId) {
    final result = <String, List<LoadBoardItem>>{
      '1구역': [],
      '2구역': [],
      '3구역': [],
      '4구역': [],
    };

    for (final item in getItems(robotId)) {
      result.putIfAbsent(item.zone, () => []);
      result[item.zone]!.add(item);
    }

    return result;
  }

  void addScannedAddress({
    required String robotId,
    required String building,
    required String unit,
  }) {
    final current = Map<String, List<LoadBoardItem>>.from(itemsByRobot.value);
    final list = List<LoadBoardItem>.from(current[robotId] ?? const []);

    final now = DateTime.now().microsecondsSinceEpoch.toString();

    list.insert(
      0,
      LoadBoardItem(
        id: '$robotId-$now',
        robotId: robotId,
        zone: _resolveZone(unit),
        building: building,
        unit: unit,
        createdAt: DateTime.now(),
        status: LoadItemStatus.loaded,
      ),
    );

    current[robotId] = list;
    itemsByRobot.value = current;
  }

  void removeItem({
    required String robotId,
    required String itemId,
  }) {
    final current = Map<String, List<LoadBoardItem>>.from(itemsByRobot.value);
    final list = List<LoadBoardItem>.from(current[robotId] ?? const []);

    list.removeWhere((item) => item.id == itemId);
    current[robotId] = list;
    itemsByRobot.value = current;
  }

  String _resolveZone(String unit) {
    final text = unit.trim();
    if (text.isEmpty) return '1구역';

    final firstDigit = int.tryParse(text[0]) ?? 1;
    final zone = ((firstDigit - 1) % 4) + 1;
    return '$zone구역';
  }
}