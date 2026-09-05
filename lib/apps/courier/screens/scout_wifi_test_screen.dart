import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';

class ScoutWifiTestScreen extends StatefulWidget {
  const ScoutWifiTestScreen({super.key});

  @override
  State<ScoutWifiTestScreen> createState() => _ScoutWifiTestScreenState();
}

enum WifiConnectionUiState {
  disconnected,
  connecting,
  connected,
  error,
}

enum ScoutDeviceState {
  unknown,
  locked,
  unlocked,
  ready,
  error,
}

enum WifiLogType {
  tx,
  rx,
  system,
  error,
}

class WifiLogEntry {
  final DateTime timestamp;
  final WifiLogType type;
  final String message;

  const WifiLogEntry({
    required this.timestamp,
    required this.type,
    required this.message,
  });
}

class _ScoutWifiTestScreenState extends State<ScoutWifiTestScreen> {
  final TextEditingController _baseUrlController =
  TextEditingController(text: 'http://192.168.0.107/');

  bool _busy = false;
  WifiConnectionUiState _connectionState = WifiConnectionUiState.disconnected;
  ScoutDeviceState _deviceState = ScoutDeviceState.unknown;

  String _latestResponse = '-';
  String? _errorText;
  String _targetLabel = 'ScoutMini-Device';
  final List<WifiLogEntry> _logs = [];

  @override
  void initState() {
    super.initState();
    _checkStatusOnEnter();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    super.dispose();
  }

  String get _baseUrl => _baseUrlController.text.trim();

  Future<void> _checkStatusOnEnter() async {
    await _sendRequest(
      actionLabel: '초기 상태 확인',
      method: 'GET',
      path: '/status',
    );
  }

  Future<void> _connectTest() async {
    await _sendRequest(
      actionLabel: '연결 테스트',
      method: 'GET',
      path: '/status',
    );
  }

  Future<void> _lock() async {
    await _sendRequest(
      actionLabel: 'LOCK 전송',
      method: 'POST',
      path: '/lock',
    );
  }

  Future<void> _unlock() async {
    await _sendRequest(
      actionLabel: 'UNLOCK 전송',
      method: 'POST',
      path: '/unlock',
    );
  }

  Future<void> _status() async {
    await _sendRequest(
      actionLabel: 'STATUS 조회',
      method: 'GET',
      path: '/status',
    );
  }

  Future<void> _sendRequest({
    required String actionLabel,
    required String method,
    required String path,
  }) async {
    if (_busy) return;

    final baseUrl = _baseUrl;
    if (baseUrl.isEmpty) {
      setState(() {
        _errorText = '서버 주소를 입력하세요.';
        _connectionState = WifiConnectionUiState.error;
      });
      return;
    }

    setState(() {
      _busy = true;
      _errorText = null;
      _connectionState = WifiConnectionUiState.connecting;
    });

    _pushLog(WifiLogType.system, '$actionLabel 시작');
    _pushLog(WifiLogType.tx, '$method $path');

    try {
      final uri = Uri.parse('$baseUrl$path');
      http.Response response;

      if (method == 'POST') {
        response = await http.post(uri).timeout(const Duration(seconds: 5));
      } else {
        response = await http.get(uri).timeout(const Duration(seconds: 5));
      }

      if (response.statusCode != 200) {
        throw HttpException('서버 응답 오류: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('응답 형식이 올바르지 않습니다.');
      }

      final success = decoded['success'] == true;
      final status = decoded['status']?.toString() ?? 'UNKNOWN';
      final event = decoded['event']?.toString();

      if (!success) {
        throw Exception(decoded['message']?.toString() ?? 'success=false returned');
      }

      _applyIncomingResponse(status);

      setState(() {
        _latestResponse = response.body;
        _connectionState = WifiConnectionUiState.connected;
      });

      _pushLog(WifiLogType.rx, response.body);

      if (event != null && event.isNotEmpty) {
        _pushLog(WifiLogType.system, 'event=$event');
      }
    } on TimeoutException {
      setState(() {
        _errorText = '요청 시간이 초과되었습니다.';
        _connectionState = WifiConnectionUiState.error;
      });
      _pushLog(WifiLogType.error, '요청 시간 초과');
    } on SocketException {
      setState(() {
        _errorText = '서버에 연결할 수 없습니다. Wi-Fi/주소를 확인하세요.';
        _connectionState = WifiConnectionUiState.error;
      });
      _pushLog(WifiLogType.error, '서버 연결 실패');
    } on FormatException catch (e) {
      setState(() {
        _errorText = '응답 파싱 실패: ${e.message}';
        _connectionState = WifiConnectionUiState.error;
      });
      _pushLog(WifiLogType.error, '응답 파싱 실패');
    } on HttpException catch (e) {
      setState(() {
        _errorText = e.message;
        _connectionState = WifiConnectionUiState.error;
      });
      _pushLog(WifiLogType.error, e.message);
    } catch (e) {
      setState(() {
        _errorText = '알 수 없는 오류: $e';
        _connectionState = WifiConnectionUiState.error;
      });
      _pushLog(WifiLogType.error, '알 수 없는 오류: $e');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  void _applyIncomingResponse(String rawStatus) {
    final upper = rawStatus.trim().toUpperCase();

    setState(() {
      if (upper == 'LOCKED') {
        _deviceState = ScoutDeviceState.locked;
      } else if (upper == 'UNLOCKED') {
        _deviceState = ScoutDeviceState.unlocked;
      } else if (upper == 'READY') {
        _deviceState = ScoutDeviceState.ready;
      } else if (upper == 'ERROR') {
        _deviceState = ScoutDeviceState.error;
      } else {
        _deviceState = ScoutDeviceState.unknown;
      }
    });
  }

  void _pushLog(WifiLogType type, String message) {
    setState(() {
      _logs.insert(
        0,
        WifiLogEntry(
          timestamp: DateTime.now(),
          type: type,
          message: message,
        ),
      );
    });
  }

  String _formatTime(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  String _connectionLabel(WifiConnectionUiState state) {
    switch (state) {
      case WifiConnectionUiState.disconnected:
        return '연결 안 됨';
      case WifiConnectionUiState.connecting:
        return '연결 확인 중';
      case WifiConnectionUiState.connected:
        return '연결됨';
      case WifiConnectionUiState.error:
        return '오류';
    }
  }

  Color _connectionColor(WifiConnectionUiState state) {
    switch (state) {
      case WifiConnectionUiState.connected:
        return AppColors.success;
      case WifiConnectionUiState.connecting:
        return AppColors.warning;
      case WifiConnectionUiState.error:
        return AppColors.error;
      case WifiConnectionUiState.disconnected:
        return AppColors.textSub;
    }
  }

  String _deviceStateLabel(ScoutDeviceState state) {
    switch (state) {
      case ScoutDeviceState.locked:
        return 'LOCKED';
      case ScoutDeviceState.unlocked:
        return 'UNLOCKED';
      case ScoutDeviceState.ready:
        return 'READY';
      case ScoutDeviceState.error:
        return 'ERROR';
      case ScoutDeviceState.unknown:
        return 'UNKNOWN';
    }
  }

  Color _deviceStateColor(ScoutDeviceState state) {
    switch (state) {
      case ScoutDeviceState.locked:
        return AppColors.deepGreen;
      case ScoutDeviceState.unlocked:
        return AppColors.warning;
      case ScoutDeviceState.ready:
        return AppColors.info;
      case ScoutDeviceState.error:
        return AppColors.error;
      case ScoutDeviceState.unknown:
        return AppColors.textSub;
    }
  }

  @override
  Widget build(BuildContext context) {
    final connColor = _connectionColor(_connectionState);
    final deviceColor = _deviceStateColor(_deviceState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scout Mini 통신 테스트'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const Text(
            '운영 앱 내부 테스트 페이지',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '운영 앱과 장비 간 명령 송수신 상태를 한 화면에서 확인합니다.',
            style: AppTextStyles.sub,
          ),
          const SizedBox(height: AppSpacing.xl),

          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('연결 설정', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _baseUrlController,
                  decoration: const InputDecoration(
                    labelText: '서버 주소',
                    hintText: '예: http://192.168.0.10:8000',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _InfoLine(label: '대상 장치', value: _targetLabel),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('상태 패널', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                _InfoLine(
                  label: '연결 상태',
                  trailing: _StateBadge(
                    label: _connectionLabel(_connectionState),
                    color: connColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _InfoLine(
                  label: '장치 상태',
                  trailing: _StateBadge(
                    label: _deviceStateLabel(_deviceState),
                    color: deviceColor,
                  ),
                ),
              ],
            ),
          ),

          if (_errorText != null) ...[
            const SizedBox(height: AppSpacing.xl),
            InfoCard(
              backgroundColor: const Color(0xFFFFF4D6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(_errorText!, style: AppTextStyles.body),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          PrimaryCtaButton(
            label: _busy ? '확인 중...' : '연결 확인',
            icon: Icons.wifi_find,
            onPressed: _busy ? null : _connectTest,
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('테스트 명령', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton(
                          onPressed: _busy ? null : _lock,
                          child: const Text('LOCK'),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: FilledButton.tonal(
                          onPressed: _busy ? null : _unlock,
                          child: const Text('UNLOCK'),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: _busy ? null : _status,
                          child: const Text('STATUS'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('최근 응답', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: deviceColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    _latestResponse,
                    style: AppTextStyles.body.copyWith(
                      color: deviceColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('로그', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: _logs.isEmpty
                      ? const Center(
                    child: Text(
                      '아직 로그가 없습니다.',
                      style: AppTextStyles.sub,
                    ),
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _logs.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return _LogTile(
                        time: _formatTime(log.timestamp),
                        type: log.type,
                        message: log.message,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;

  const _InfoLine({
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 92,
          child: Text(label, style: AppTextStyles.sub),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: trailing ??
              Text(
                value ?? '-',
                style: AppTextStyles.body,
              ),
        ),
      ],
    );
  }
}

class _StateBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StateBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          label,
          style: AppTextStyles.sub.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final String time;
  final WifiLogType type;
  final String message;

  const _LogTile({
    required this.time,
    required this.type,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    late final String prefix;
    late final Color color;

    switch (type) {
      case WifiLogType.tx:
        prefix = 'TX';
        color = AppColors.deepGreen;
        break;
      case WifiLogType.rx:
        prefix = 'RX';
        color = AppColors.info;
        break;
      case WifiLogType.system:
        prefix = 'SYS';
        color = AppColors.textSub;
        break;
      case WifiLogType.error:
        prefix = 'ERR';
        color = AppColors.error;
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 76,
          child: Text(
            '$time  $prefix',
            style: AppTextStyles.sub.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: AppTextStyles.sub.copyWith(
              color: AppColors.textMain,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}