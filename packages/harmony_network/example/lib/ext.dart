extension FutureExt<T> on Future<T> {
  Future<FutureResult<T>> sealed() async {
    try {
      final result = await this;
      return FutureResult.success(result);
    } on Exception catch (e) {
      return FutureResult.error(e);
    }
  }
}

class FutureResult<T> {
  final T? data;
  final Exception? exception;
  FutureResult._(this.data, this.exception);

  FutureResult.success(this.data) : this.exception = null;
  FutureResult.error(this.exception) : this.data = null;
}
