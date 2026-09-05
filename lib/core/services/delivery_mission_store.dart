import 'package:flutter/foundation.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';

class DeliveryMissionStore {
  DeliveryMissionStore._();

  static final DeliveryMissionStore instance = DeliveryMissionStore._();

  final ValueNotifier<DeliveryMissionItem?> activeMission =
  ValueNotifier<DeliveryMissionItem?>(null);

  final ValueNotifier<List<DeliveryMissionItem>> history =
  ValueNotifier<List<DeliveryMissionItem>>([]);

  void startMission({
    required String robotId,
    required String building,
    required String unit,
    required int quantity,
  }) {
    activeMission.value = DeliveryMissionItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      robotId: robotId,
      building: building,
      unit: unit,
      quantity: quantity,
      startedAt: DateTime.now(),
      status: DeliveryMissionStatus.moving,
      currentStep: 2,
      etaSeconds: 78,
    );
  }

  void advanceStep() {
    final current = activeMission.value;
    if (current == null) return;

    if (current.currentStep >= 3) return;

    final nextStep = current.currentStep + 1;
    final nextEta = (current.etaSeconds - 20).clamp(0, 99999);

    activeMission.value = current.copyWith(
      currentStep: nextStep,
      etaSeconds: nextEta,
      status: nextStep >= 3
          ? DeliveryMissionStatus.arrived
          : DeliveryMissionStatus.moving,
    );
  }

  void markArrived() {
    final current = activeMission.value;
    if (current == null) return;

    activeMission.value = current.copyWith(
      status: DeliveryMissionStatus.arrived,
      currentStep: 3,
      etaSeconds: 0,
    );
  }

  void completeActiveMission() {
    final current = activeMission.value;
    if (current == null) return;

    final completed = current.copyWith(
      status: DeliveryMissionStatus.completed,
      currentStep: 4,
      etaSeconds: 0,
    );

    history.value = [completed, ...history.value];
    activeMission.value = null;
  }

  DeliveryMissionItem? latestMissionForAddress({
    required String building,
    required String unit,
  }) {
    final active = activeMission.value;
    if (active != null &&
        active.building == building &&
        active.unit == unit) {
      return active;
    }

    for (final item in history.value) {
      if (item.building == building && item.unit == unit) {
        return item;
      }
    }

    return null;
  }

  DeliveryMissionItem? latestCompletedForAddress({
    required String building,
    required String unit,
  }) {
    for (final item in history.value) {
      if (item.building == building &&
          item.unit == unit &&
          item.status == DeliveryMissionStatus.completed) {
        return item;
      }
    }
    return null;
  }

  List<DeliveryMissionItem> historyForAddress({
    required String building,
    required String unit,
  }) {
    return history.value
        .where((item) => item.building == building && item.unit == unit)
        .toList();
  }

  DeliveryMissionItem? activeMissionForRobot(String robotId) {
    final active = activeMission.value;
    if (active == null) return null;
    if (active.robotId != robotId) return null;
    return active;
  }

  bool isRobotBusy(String robotId) {
    return activeMissionForRobot(robotId) != null;
  }

  int get activeMissionCount {
    return activeMission.value == null ? 0 : 1;
  }
}