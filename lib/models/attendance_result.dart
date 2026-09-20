class LocationVerification {
  final double distance;
  final bool isValid;
  final double campusLat;
  final double campusLon;
  final double maxRadius;

  LocationVerification({
    required this.distance,
    required this.isValid,
    required this.campusLat,
    required this.campusLon,
    required this.maxRadius,
  });

  factory LocationVerification.fromJson(Map<String, dynamic> json) {
    return LocationVerification(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      isValid: json['isValid'] as bool? ?? false,
      campusLat: (json['campusLat'] as num?)?.toDouble() ?? 0.0,
      campusLon: (json['campusLon'] as num?)?.toDouble() ?? 0.0,
      maxRadius: (json['maxRadius'] as num?)?.toDouble() ?? 150.0,
    );
  }
}

class AiVerification {
  final String verdict;
  final bool isRealPerson;
  final bool isFaceClear;
  final bool spoofDetected;
  final int confidence;
  final String reason;
  final String environment;

  AiVerification({
    required this.verdict,
    required this.isRealPerson,
    required this.isFaceClear,
    required this.spoofDetected,
    required this.confidence,
    required this.reason,
    required this.environment,
  });

  factory AiVerification.fromJson(Map<String, dynamic> json) {
    return AiVerification(
      verdict: json['verdict'] as String? ?? 'PENDING_REVIEW',
      isRealPerson: json['isRealPerson'] as bool? ?? true,
      isFaceClear: json['isFaceClear'] as bool? ?? true,
      spoofDetected: json['spoofDetected'] as bool? ?? false,
      confidence: json['confidence'] as int? ?? 50,
      reason: json['reason'] as String? ?? '',
      environment: json['environment'] as String? ?? '',
    );
  }
}

class AttendanceResult {
  final String id;
  final String mahasiswaId;
  final String name;
  final String nim;
  final String jurusan;
  final int semester;
  final String? checkIn;
  final String status;
  final String? notes;
  final String? photo;
  final LocationVerification? location;
  final AiVerification? ai;

  AttendanceResult({
    required this.id,
    required this.mahasiswaId,
    required this.name,
    required this.nim,
    required this.jurusan,
    required this.semester,
    this.checkIn,
    required this.status,
    this.notes,
    this.photo,
    this.location,
    this.ai,
  });

  factory AttendanceResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final verif = json['verification'] as Map<String, dynamic>? ?? {};

    return AttendanceResult(
      id: data['id'] as String? ?? '',
      mahasiswaId: data['mahasiswaId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      nim: data['nim'] as String? ?? '',
      jurusan: data['jurusan'] as String? ?? '',
      semester: data['semester'] as int? ?? 1,
      checkIn: data['checkIn'] as String?,
      status: data['status'] as String? ?? 'ABSENT',
      notes: data['notes'] as String?,
      photo: data['photo'] as String?,
      location: verif['location'] != null
          ? LocationVerification.fromJson(verif['location'])
          : (data['distance'] != null
                ? LocationVerification(
                    distance: (data['distance'] as num?)?.toDouble() ?? 0.0,
                    isValid: data['isLocationValid'] as bool? ?? false,
                    campusLat: 0.0,
                    campusLon: 0.0,
                    maxRadius: 150.0,
                  )
                : null),
      ai: verif['ai'] != null
          ? AiVerification.fromJson(verif['ai'])
          : (data['aiVerification'] != null
                ? AiVerification.fromJson(data['aiVerification'])
                : null),
    );
  }
}
