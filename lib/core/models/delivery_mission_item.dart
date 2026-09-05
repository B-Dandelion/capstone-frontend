enum DeliveryMissionStatus {
  moving,
  arrived,
  completed,
}

class DeliveryMissionItem {
  final String id;
  final String robotId;
  final String building;
  final String unit;
  final int quantity;
  final DateTime startedAt;
  final DeliveryMissionStatus status;
  final int currentStep;
  final int etaSeconds;

  const DeliveryMissionItem({
    required this.id,
    required this.robotId,
    required this.building,
    required this.unit,
    required this.quantity,
    required this.startedAt,
    required this.status,
    required this.currentStep,
    required this.etaSeconds,
  });

  String get addressLabel => '${building}동 ${unit}호';

  String get etaLabel {
    final minutes = etaSeconds ~/ 60;
    final seconds = etaSeconds % 60;
    return '${minutes}분 ${seconds}초';
  }

  DeliveryMissionItem copyWith({
    String? id,
    String? robotId,
    String? building,
    String? unit,
    int? quantity,
    DateTime? startedAt,
    DeliveryMissionStatus? status,
    int? currentStep,
    int? etaSeconds,
  }) {
    return DeliveryMissionItem(
      id: id ?? this.id,
      robotId: robotId ?? this.robotId,
      building: building ?? this.building,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      startedAt: startedAt ?? this.startedAt,
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      etaSeconds: etaSeconds ?? this.etaSeconds,
    );
  }
}