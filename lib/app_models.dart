class DetectionResult {
  final String label;
  final double confidence;
  final double x;
  final double y;
  final double width;
  final double height;

  const DetectionResult({
    required this.label,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
}

class PoseKeypoint {
  final String name;
  final double x;
  final double y;
  final double confidence;

  const PoseKeypoint({
    required this.name,
    required this.x,
    required this.y,
    required this.confidence,
  });
}

class PoseFrameResult {
  final int frameIndex;
  final DateTime timestamp;
  final DetectionResult? personBox;
  final List<PoseKeypoint> keypoints;

  final double trunkLeanAngle;
  final double armSwingAngle;
  final double kneeLiftAngle;
  final double strideSymmetry;
  final double postureScore;

  final String postureStatus; // good / warning / bad
  final String issueCode;
  final String feedbackText;

  const PoseFrameResult({
    required this.frameIndex,
    required this.timestamp,
    required this.personBox,
    required this.keypoints,
    required this.trunkLeanAngle,
    required this.armSwingAngle,
    required this.kneeLiftAngle,
    required this.strideSymmetry,
    required this.postureScore,
    required this.postureStatus,
    required this.issueCode,
    required this.feedbackText,
  });
}

class RunningSessionSummary {
  final String sessionId;
  final DateTime startedAt;
  final DateTime endedAt;

  final double durationMinutes;
  final double distanceKm;
  final int avgHeartRate;
  final double avgPace;
  final double finalPostureScore;

  final Map<String, int> issueCounts;
  final String topIssueCode;
  final String topFeedback;

  const RunningSessionSummary({
    required this.sessionId,
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    required this.distanceKm,
    required this.avgHeartRate,
    required this.avgPace,
    required this.finalPostureScore,
    required this.issueCounts,
    required this.topIssueCode,
    required this.topFeedback,
  });
}