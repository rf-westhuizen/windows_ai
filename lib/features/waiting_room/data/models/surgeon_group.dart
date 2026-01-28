import 'package:freezed_annotation/freezed_annotation.dart';

part 'surgeon_group.freezed.dart';
part 'surgeon_group.g.dart';

/// Represents a surgeon's case list (Main Tile) in the waiting room.
///
/// Each PDF/file dropped creates one SurgeonGroup containing multiple [SurgicalCase]s.
/// Detached cases create new SurgeonGroups with [isDetached] = true.
@freezed
class SurgeonGroup with _$SurgeonGroup {
  const factory SurgeonGroup({
    /// Unique identifier for this group
    required String id,

    /// Surgeon's full name
    String? surgeonName,

    /// Hospital name
    String? hospital,

    /// Initial start time for first case
    String? startTime,

    /// Source file name (PDF/image that was processed)
    required String sourceFileName,

    /// Whether this group was created from a detached case
    @Default(false) bool isDetached,

    /// Original group ID if this is a detached group
    String? detachedFromGroupId,

    /// Timestamp when this group was created
    required DateTime createdAt,
  }) = _SurgeonGroup;

  factory SurgeonGroup.fromJson(Map<String, dynamic> json) =>
      _$SurgeonGroupFromJson(json);
}
