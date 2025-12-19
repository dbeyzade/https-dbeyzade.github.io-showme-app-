enum RecognitionResultType {
  math,
  formula,
}

class RecognitionResult {
  final RecognitionResultType type;

  /// What should be shown as the primary result text.
  /// - For math: usually just the number
  /// - For formula: the formula line (kept in `formula`) and inventor name
  final String displayText;

  /// Original/canonical formula text (only for `formula`).
  final String? formula;

  /// Inventor/physicist name (only for `formula`).
  final String? inventor;

  /// Asset image path (only for `formula`).
  final String? imageAsset;

  const RecognitionResult._({
    required this.type,
    required this.displayText,
    this.formula,
    this.inventor,
    this.imageAsset,
  });

  factory RecognitionResult.math({required String value}) {
    return RecognitionResult._(
      type: RecognitionResultType.math,
      displayText: value,
    );
  }

  factory RecognitionResult.formula({
    required String formula,
    required String inventor,
    required String imageAsset,
  }) {
    return RecognitionResult._(
      type: RecognitionResultType.formula,
      displayText: inventor,
      formula: formula,
      inventor: inventor,
      imageAsset: imageAsset,
    );
  }
}
