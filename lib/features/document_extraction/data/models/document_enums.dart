/// Supported document types for extraction.
enum DocumentType {
  pdf('PDF Document', ['.pdf']),
  image('Image File', ['.png', '.jpg', '.jpeg', '.webp', '.gif']);

  const DocumentType(this.displayName, this.extensions);

  final String displayName;
  final List<String> extensions;

  /// Determines the document type from a file path.
  static DocumentType? fromPath(String path) {
    final lowercasePath = path.toLowerCase();
    for (final type in values) {
      for (final ext in type.extensions) {
        if (lowercasePath.endsWith(ext)) {
          return type;
        }
      }
    }
    return null;
  }

  /// Creates a DocumentType from a file extension string.
  /// 
  /// The extension should include the dot (e.g., '.pdf', '.png').
  /// Throws [ArgumentError] if the extension is not supported.
  static DocumentType fromExtension(String ext) {
    final lowercaseExt = ext.toLowerCase();
    for (final type in values) {
      if (type.extensions.contains(lowercaseExt)) {
        return type;
      }
    }
    throw ArgumentError('Unsupported file type: $ext');
  }
}

/// Status of the extraction process.
enum ExtractionStatus {
  pending('Pending'),
  processing('Processing...'),
  completed('Completed'),
  failed('Failed');

  const ExtractionStatus(this.displayName);

  final String displayName;
}
