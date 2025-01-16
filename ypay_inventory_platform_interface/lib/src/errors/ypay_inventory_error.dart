/// YPayInventory error.
abstract class YPayInventoryError implements Exception {
  /// Constructs a YPayInventoryError.
  YPayInventoryError({
    required this.message,
    required this.data,
  });

  /// Contains error message.
  final String message;

  /// Contains error data.
  final String data;

  @override
  String toString() {
    return '$message\n$data';
  }
}

/// Initialization error.
class YPayInventoryInitializeError extends YPayInventoryError {
  /// Constructs a YPayInventoryInitializeError.
  YPayInventoryInitializeError({
    required String message,
    required String data,
  }) : super(message: message, data: data);
}

/// Client error.
class YPayInventoryValidationError extends YPayInventoryError {
  /// Constructs a YPayInventoryValidationError.
  YPayInventoryValidationError({
    required String message,
    required String data,
    required this.code,
  }) : super(message: message, data: data);

  /// Contains error code.
  final String code;
}

/// Internal error.
class YPayInventoryInternalError extends YPayInventoryError {
  /// Constructs a YPayInventoryInternalError.
  YPayInventoryInternalError({
    required String message,
    required String data,
  }) : super(message: message, data: data);
}

/// Unknown error.
class YPayInventoryUnknownError extends YPayInventoryError {
  /// Constructs a YPayInventoryUnknownError.
  YPayInventoryUnknownError({
    required String message,
    required String data,
  }) : super(message: message, data: data);
}
