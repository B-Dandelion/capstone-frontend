import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/load_board_screen.dart';
import 'package:capstone_frontend/core/services/label_ocr_service.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/utils/address_parser.dart';

class CameraScanScreen extends StatefulWidget {
  final String robotId;

  const CameraScanScreen({
    super.key,
    required this.robotId,
  });

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  final LabelOcrService _ocrService = LabelOcrService();

  bool _isInitializing = true;
  bool _isProcessing = false;
  String? _errorMessage;

  String _rawText = '';
  ParsedAddress? _parsedAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _ocrService.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _isInitializing = true;
        _errorMessage = null;
      });

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = '사용 가능한 카메라가 없습니다.';
          _isInitializing = false;
        });
        return;
      }

      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } on CameraException catch (e) {
      String message = '카메라 초기화에 실패했습니다.';
      if (e.code == 'CameraAccessDenied') {
        message = '카메라 권한이 거부되었습니다.';
      } else if (e.code == 'CameraAccessDeniedWithoutPrompt') {
        message = '카메라 권한이 비활성화되어 있습니다. 설정에서 허용해주세요.';
      }

      setState(() {
        _errorMessage = message;
        _isInitializing = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = '카메라를 초기화하지 못했습니다.';
        _isInitializing = false;
      });
    }
  }

  Future<void> _captureAndRecognize() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isProcessing) {
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
        _errorMessage = null;
      });

      final file = await controller.takePicture();
      final rawText = await _ocrService.recognizeText(file.path);
      final parsed = AddressParser.parse(rawText);

      if (!mounted) return;

      setState(() {
        _rawText = rawText;
        _parsedAddress = parsed;
        _isProcessing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = '촬영 또는 OCR 처리 중 오류가 발생했습니다.';
        _isProcessing = false;
      });
    }
  }

  void _confirmAdd() {
    final parsed = _parsedAddress;
    if (parsed == null) return;

    RobotLoadStore.instance.addScannedAddress(
      robotId: widget.robotId,
      building: parsed.building,
      unit: parsed.unit,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${parsed.label} 적재 카드가 추가되었습니다.')),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoadBoardScreen(robotId: widget.robotId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('카메라 스캔'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildPreview(controller),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('인식 결과', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.md),
                      if (_parsedAddress != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            _parsedAddress!.label,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Text(
                          '동/호수가 인식되었습니다. 확인 후 적재 카드에 반영하세요.',
                          style: AppTextStyles.sub,
                        ),
                      ] else if (_rawText.isNotEmpty) ...[
                        const Text(
                          '동/호수를 자동 추출하지 못했습니다.',
                          style: AppTextStyles.body,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(_rawText, style: AppTextStyles.sub),
                      ] else ...[
                        const Text(
                          '송장을 화면 중앙 가이드 안에 맞춘 뒤 촬영하세요.',
                          style: AppTextStyles.sub,
                        ),
                      ],
                    ],
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _isInitializing || _isProcessing
                        ? null
                        : _captureAndRecognize,
                    icon: _isProcessing
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.camera_alt_outlined),
                    label: Text(_isProcessing ? '인식 중...' : '촬영 및 인식'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _parsedAddress == null ? null : _confirmAdd,
                    child: const Text('적재 카드에 추가'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(CameraController? controller) {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            _errorMessage!,
            style: AppTextStyles.body.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Text(
          '카메라를 사용할 수 없습니다.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(controller),
        Center(
          child: Container(
            width: 280,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}