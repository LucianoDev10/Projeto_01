import 'package:flutter/material.dart';

import '../../model/usuarios/usuario2_model.dart';

class UserProvider extends ChangeNotifier {
  Usuario2? _currentUser;

  Usuario2? get currentUser => _currentUser;

  // Função para atualizar o usuário atual
  void updateUser(Usuario2 user) {
    _currentUser = user;
    notifyListeners();
  }
}
