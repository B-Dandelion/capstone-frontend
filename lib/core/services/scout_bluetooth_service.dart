import 'dart:async';

import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';

import 'package:capstone_frontend/core/models/scout_bluetooth_models.dart';

class ScoutBluetoothService {
  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();

  final StreamController<bool> _adapterEnabledController =
  StreamController<bool>.broadcast();
  final StreamController<ScoutBtConnectionUiState> _connectionController =
  StreamController<ScoutBtConnectionUiState>.broadcast();
  final StreamController<String> _incomingController =
  StreamController<String>.broadcast();
  final StreamController<String> _errorController =
  StreamController<String>.broadcast();

  StreamSubscription? _adapterSub;
  StreamSubscription? _connectionSub;
  StreamSubscription? _dataSub;

  bool _initialized = false;
  String? _connectedAddress;

  Stream<bool> get adapterEnabledStream => _adapterEnabledController.stream;
  Stream<ScoutBtConnectionUiState> get connectionStateStream =>
      _connectionController.stream;
  Stream<String> get incomingDataStream => _incomingController.stream;
  Stream<String> get errorStream => _errorController.stream;

  String? get connectedAddress => _connectedAddress;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _adapterSub = _bluetooth.onStateChanged.listen(
          (state) {
        _adapterEnabledController.add(state.isEnabled);
      },
      onError: (Object e) {
        _errorController.add('Bluetooth 상태 스트림 오류: $e');
      },
    );

    _connectionSub = _bluetooth.onConnectionChanged.listen(
          (connectionState) {
        if (connectionState.isConnected) {
          _connectedAddress = connectionState.deviceAddress;
          _connectionController.add(ScoutBtConnectionUiState.connected);
        } else {
          _connectedAddress = null;
          _connectionController.add(ScoutBtConnectionUiState.disconnected);
        }
      },
      onError: (Object e) {
        _connectionController.add(ScoutBtConnectionUiState.error);
        _errorController.add('연결 상태 스트림 오류: $e');
      },
    );

    _dataSub = _bluetooth.onDataReceived.listen(
          (data) {
        final text = data.asString();
        if (text.isNotEmpty) {
          _incomingController.add(text);
        }
      },
      onError: (Object e) {
        _errorController.add('수신 스트림 오류: $e');
      },
    );

    try {
      final enabled = await _bluetooth.isBluetoothEnabled();
      _adapterEnabledController.add(enabled);
    } catch (e) {
      _errorController.add('Bluetooth 활성 상태 확인 실패: $e');
    }
  }

  Future<bool> isSupported() async {
    return _bluetooth.isBluetoothSupported();
  }

  Future<bool> isEnabled() async {
    return _bluetooth.isBluetoothEnabled();
  }

  Future<bool> enableBluetooth() async {
    return _bluetooth.enableBluetooth();
  }

  Future<List<ScoutBtDevice>> getPairedDevices() async {
    final devices = await _bluetooth.getPairedDevices();
    return devices
        .map(
          (d) => ScoutBtDevice(
        name: d.name,
        address: d.address,
        paired: d.paired,
      ),
    )
        .toList();
  }

  Future<bool> connect(String address) async {
    _connectionController.add(ScoutBtConnectionUiState.connecting);
    try {
      final ok = await _bluetooth.connect(address);
      if (!ok) {
        _connectionController.add(ScoutBtConnectionUiState.error);
        _errorController.add('기기 연결 실패');
      }
      return ok;
    } catch (e) {
      _connectionController.add(ScoutBtConnectionUiState.error);
      _errorController.add('기기 연결 중 예외 발생: $e');
      return false;
    }
  }

  Future<bool> disconnect() async {
    _connectionController.add(ScoutBtConnectionUiState.disconnecting);
    try {
      final ok = await _bluetooth.disconnect();
      if (!ok) {
        _connectionController.add(ScoutBtConnectionUiState.error);
        _errorController.add('기기 연결 해제 실패');
      }
      return ok;
    } catch (e) {
      _connectionController.add(ScoutBtConnectionUiState.error);
      _errorController.add('연결 해제 중 예외 발생: $e');
      return false;
    }
  }

  Future<bool> sendCommand(
      String command, {
        bool appendNewline = true,
      }) async {
    final payload = appendNewline ? '$command\n' : command;

    try {
      return await _bluetooth.sendString(payload);
    } catch (e) {
      _errorController.add('명령 전송 실패: $e');
      return false;
    }
  }

  Future<void> dispose() async {
    await _adapterSub?.cancel();
    await _connectionSub?.cancel();
    await _dataSub?.cancel();

    await _adapterEnabledController.close();
    await _connectionController.close();
    await _incomingController.close();
    await _errorController.close();
  }
}