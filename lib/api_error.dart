sealed class ApiError {
  String? errMsg;
  int? errCode;
}

class SocketTimeoutError extends ApiError {
  @override
  int? get errCode => null;

  @override
  String? get errMsg => "No internet connection";
}

class HttpError extends ApiError {
  @override
  int? get errCode => null;

  @override
  String? get errMsg => "HTTP Exception";
}

class FormatError extends ApiError {
  @override
  int? get errCode => null;

  @override
  String? get errMsg => "Format Exception";
}

class UnknownError extends ApiError {
  final int code;
  final String msg;

  UnknownError(this.code, this.msg);

  @override
  int? get errCode => code;

  @override
  String? get errMsg => msg;
}
