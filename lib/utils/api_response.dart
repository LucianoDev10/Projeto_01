class ApiResponse<T> {
  bool ok = false;
  String msg = "";
  T? result;

  ApiResponse.ok(this.result) {
    ok = true;
  }

  ApiResponse.error(this.msg) {
    ok = false;
  }

  bool get isError => !ok;

  String get errorMessage => msg;
}
