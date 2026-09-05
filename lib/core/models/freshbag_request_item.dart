enum FreshbagRequestStatus {
  requested,
  failed,
  completed,
}

class FreshbagRequestItem {
  final String id;
  final String building;
  final String unit;
  final DateTime requestedAt;
  final FreshbagRequestStatus status;
  final int failedCount;
  final int missedDays;

  const FreshbagRequestItem({
    required this.id,
    required this.building,
    required this.unit,
    required this.requestedAt,
    required this.status,
    required this.failedCount,
    required this.missedDays,
  });

  String get addressLabel => '${building}동 ${unit}호';

  FreshbagRequestItem copyWith({
    String? id,
    String? building,
    String? unit,
    DateTime? requestedAt,
    FreshbagRequestStatus? status,
    int? failedCount,
    int? missedDays,
  }) {
    return FreshbagRequestItem(
      id: id ?? this.id,
      building: building ?? this.building,
      unit: unit ?? this.unit,
      requestedAt: requestedAt ?? this.requestedAt,
      status: status ?? this.status,
      failedCount: failedCount ?? this.failedCount,
      missedDays: missedDays ?? this.missedDays,
    );
  }
}