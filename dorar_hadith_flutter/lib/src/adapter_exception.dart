enum FlutterAdapterFailure {
  missingAsset,
  incompatibleSchema,
  integrity,
  installation,
  configurationConflict,
}

class DorarFlutterAdapterException implements Exception {
  const DorarFlutterAdapterException(this.failure, this.message, {this.cause});
  final FlutterAdapterFailure failure;
  final String message;
  final Object? cause;
  @override
  String toString() =>
      'DorarFlutterAdapterException(${failure.name}): $message';
}
