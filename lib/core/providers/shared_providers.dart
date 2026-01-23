import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Data class for passing extracted patient data to the planner.
class ExtractedPatientData {
  final String name;
  final int age;
  final String? dateOfBirth;
  final String? address;
  final String? phone;
  final String? email;
  final String? idNumber;

  const ExtractedPatientData({
    required this.name,
    required this.age,
    this.dateOfBirth,
    this.address,
    this.phone,
    this.email,
    this.idNumber,
  });
}

/// Provider to hold extracted patient data for transfer to planner.
final extractedPatientDataProvider = StateProvider<ExtractedPatientData?>((ref) => null);

/// Provider to trigger navigation to planner tab.
final navigateToPlannerProvider = StateProvider<bool>((ref) => false);
