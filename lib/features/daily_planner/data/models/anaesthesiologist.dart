import 'package:freezed_annotation/freezed_annotation.dart';

part 'anaesthesiologist.freezed.dart';
part 'anaesthesiologist.g.dart';

/// Represents an Anaesthesiologist in the Daily Planner.
@freezed
class Anaesthesiologist with _$Anaesthesiologist {
  const factory Anaesthesiologist({
    /// Unique identifier
    required String id,

    /// Anaesthesiologist's name
    required String name,

    /// Whether this is a helper anaesthesiologist
    @Default(false) bool isHelper,

    /// Timestamp when created
    required DateTime createdAt,
  }) = _Anaesthesiologist;

  factory Anaesthesiologist.fromJson(Map<String, dynamic> json) =>
      _$AnaesthesiologistFromJson(json);
}
