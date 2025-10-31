abstract base class AppError {
  final String message;
  const AppError(this.message);

  @override
  String toString() => message;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}