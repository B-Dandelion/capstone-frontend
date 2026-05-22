enum ScoutBtConnectionUiState {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

enum ScoutDeviceState {
  unknown,
  locked,
  unlocked,
  ready,
  error,
}

enum ScoutBtLogType {
  tx,
  rx,
  system,
  error,
}

class ScoutBtDevice {
  final String name;
  final String address;
  final bool paired;

  const ScoutBtDevice({
    required this.name,
    required this.address,
    required this.paired,
  });

  String get displayName {
    if (name.trim().isEmpty) return address;
    return name;
  }
}

class ScoutBtLogEntry {
  final DateTime timestamp;
  final ScoutBtLogType type;
  final String message;

  const ScoutBtLogEntry({
    required this.timestamp,
    required this.type,
    required this.message,
  });
}