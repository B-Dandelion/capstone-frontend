enum LoadItemStatus {
  loaded,
  completed,
}

class LoadBoardItem {
  final String id;
  final String robotId;
  final String zone;
  final String building;
  final String unit;
  final DateTime createdAt;
  final LoadItemStatus status;

  const LoadBoardItem({
    required this.id,
    required this.robotId,
    required this.zone,
    required this.building,
    required this.unit,
    required this.createdAt,
    required this.status,
  });

  String get addressLabel => '$building동 $unit호';
}