enum SecurityAlertLevel {
  normal,
  warning,
  resolved,
}

enum SecurityEventType {
  forcedOpenAttempt,
  doorOpenedUnexpectedly,
  shockDetected,
}

extension SecurityAlertLevelX on SecurityAlertLevel {
  String get label {
    switch (this) {
      case SecurityAlertLevel.normal:
        return '정상';
      case SecurityAlertLevel.warning:
        return '경고';
      case SecurityAlertLevel.resolved:
        return '정상 복귀';
    }
  }
}

extension SecurityEventTypeX on SecurityEventType {
  String get label {
    switch (this) {
      case SecurityEventType.forcedOpenAttempt:
        return '강제 개방 시도';
      case SecurityEventType.doorOpenedUnexpectedly:
        return '비정상 문 열림';
      case SecurityEventType.shockDetected:
        return '충격 감지';
    }
  }
}

class SecurityAlertItem {
  final SecurityAlertLevel level;
  final SecurityEventType type;
  final String time;
  final String robotId;
  final String location;
  final String description;

  const SecurityAlertItem({
    required this.level,
    required this.type,
    required this.time,
    required this.robotId,
    required this.location,
    required this.description,
  });
}