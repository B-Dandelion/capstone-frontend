import 'package:flutter/foundation.dart';
import 'package:capstone_frontend/core/models/freshbag_request_item.dart';

class FreshbagRequestStore {
  FreshbagRequestStore._();

  static final FreshbagRequestStore instance = FreshbagRequestStore._();

  final ValueNotifier<List<FreshbagRequestItem>> items =
  ValueNotifier<List<FreshbagRequestItem>>([
    FreshbagRequestItem(
      id: 'req-1',
      building: '101',
      unit: '1203',
      requestedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      status: FreshbagRequestStatus.requested,
      failedCount: 0,
      missedDays: 0,
    ),
    FreshbagRequestItem(
      id: 'req-2',
      building: '103',
      unit: '903',
      requestedAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: FreshbagRequestStatus.failed,
      failedCount: 2,
      missedDays: 1,
    ),
    FreshbagRequestItem(
      id: 'req-3',
      building: '105',
      unit: '1104',
      requestedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: FreshbagRequestStatus.failed,
      failedCount: 3,
      missedDays: 2,
    ),
  ]);

  List<FreshbagRequestItem> getAll() => List.unmodifiable(items.value);

  List<FreshbagRequestItem> getRequested() {
    return getAll()
        .where((e) => e.status == FreshbagRequestStatus.requested)
        .toList();
  }

  List<FreshbagRequestItem> getFailed() {
    return getAll()
        .where((e) => e.status == FreshbagRequestStatus.failed)
        .toList();
  }

  List<FreshbagRequestItem> getCompleted() {
    return getAll()
        .where((e) => e.status == FreshbagRequestStatus.completed)
        .toList();
  }

  List<FreshbagRequestItem> getMissed() {
    return getAll().where((e) => e.missedDays > 0).toList();
  }

  FreshbagRequestItem? latestForAddress({
    required String building,
    required String unit,
  }) {
    for (final item in items.value) {
      if (item.building == building && item.unit == unit) {
        return item;
      }
    }
    return null;
  }

  void addRequest({
    required String building,
    required String unit,
  }) {
    final current = List<FreshbagRequestItem>.from(items.value);

    current.insert(
      0,
      FreshbagRequestItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        building: building,
        unit: unit,
        requestedAt: DateTime.now(),
        status: FreshbagRequestStatus.requested,
        failedCount: 0,
        missedDays: 0,
      ),
    );

    items.value = current;
  }

  void markCompleted(String id) {
    final current = items.value.map((item) {
      if (item.id != id) return item;
      return item.copyWith(
        status: FreshbagRequestStatus.completed,
        missedDays: 0,
      );
    }).toList();

    items.value = current;
  }

  void markFailed(String id) {
    final current = items.value.map((item) {
      if (item.id != id) return item;
      return item.copyWith(
        status: FreshbagRequestStatus.failed,
        failedCount: item.failedCount + 1,
        missedDays: item.missedDays + 1,
      );
    }).toList();

    items.value = current;
  }
}