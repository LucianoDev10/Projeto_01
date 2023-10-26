import 'dart:async';
import 'package:projeto_01_teste/login/login_api.dart';

import '../model/usuarios/usuario2_model.dart';
import '../utils/api_response.dart';

class LoginBloc {
  final _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse<Usuario2>> login(String email, String senha) async {
    _streamController.add(true);

    ApiResponse<Usuario2> response = await LoginApi.login(email, senha);

    _streamController.add(false);

    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
