import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages_admin/HomeAdmin.dart';

import '../home_page.dart';
import '../model/usuarios/usuario2_model.dart';
//import '../model/usuario_model.dart';
import '../pages_entregador/HomeEntregador.dart';
import '../utils/alert.dart';
import '../utils/api_response.dart';
import '../utils/custom_icons_icons.dart';
import '../utils/navs.dart';
import '../utils/typograph.dart';
import 'login_bloc.dart';
import 'login_cadastro.dart';
import 'login_esqueci_senha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = LoginBloc();

  final _formKey = GlobalKey<FormState>();
  final _vEmail = TextEditingController();
  final _vSenha = TextEditingController();
  final _focusSenha = FocusNode();
  bool showProgress = false;
  bool _showPassword = true;

  @override
  void initState() {
    super.initState();

    /*Future<Usuario?> future = Usuario.get();
    future.then((Usuario? user) {
      if (user != null) {
        /*setState(() {
          push(context, const HomePage(), replace: true);
        });*/
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  String? _validarEmail(String? text) {
    if (text!.isEmpty) {
      return "Digite seu e-mail";
    }
    return null;
  }

  String? _validarSenha(String? text) {
    if (text!.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha precisa ter ao menos 7 caracteres";
    }
    return null;
  }

  Future<void> _onClickLogin() async {
    bool formOk = _formKey.currentState!.validate();
    if (!formOk) {
      return;
    }

    String email = _vEmail.text;
    String senha = _vSenha.text;
    ApiResponse<Usuario2>? response = await _bloc.login(email, senha);

    if (response != null) {
      Usuario2 usuario = response.result!;

      String usuTipo = usuario.tipo!;

      if (response.ok) {
        print("print do response.ok");
        if (usuTipo == "Cliente") {
          push(context, const HomePage(), replace: true);
        } else if (usuTipo == "Admin") {
          push(context, const HomeAdmin(), replace: true);
        } else {
          push(context, const HomeEntregador(), replace: true);
        }
      } else {
        alerta(context, response.msg);
      }
    } else {
      alerta(
          context, "Erro de autenticação"); // Lidar com o caso de resposta nula
    }
  }

  _body() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      'assets/images/paint_result.png',
                      fit: BoxFit.contain,
                      height: 220,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: corTxtLogin,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        if (_focusSenha != null) {
                          FocusScope.of(context).requestFocus(_focusSenha);
                        }
                      },
                      controller: _vEmail,
                      validator: _validarEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        prefixIcon: const Icon(
                          CustomIcons.at,
                          size: 20,
                        ),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: corFundoLogin),
                        filled: true,
                        fillColor: Color(int.parse("0xffF4F4F4")),
                        hintText: 'email@dominio.com',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      controller: _vSenha,
                      validator: _validarSenha,
                      keyboardType: TextInputType.text,
                      focusNode: _focusSenha,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            _showPassword == true
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        prefixIcon: const Icon(
                          CustomIcons.lock_keyhole,
                          size: 20,
                        ),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: corFundoLogin),
                        filled: true,
                        fillColor: Color(int.parse("0xffF4F4F4")),
                        hintText: '**********',
                      ),
                      obscureText: _showPassword == true ? true : false,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      push(context, const EsqueciSenhaPage(), replace: true);
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 8, left: 25),
                      child: const Text(
                        'Esqueci a senha',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: corInfo),
                      ),
                    ),
                  ),
                  StreamBuilder<bool>(
                      stream: _bloc.stream,
                      initialData: false,
                      builder: (context, snapshot) {
                        showProgress = snapshot.data!;
                        return Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onClickLogin,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                showProgress
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Entrar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                              ],
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(corInfo)),
                          ),
                        );
                      }),
                  const Center(
                    child: Text(
                      'ou entre com...',
                      style: TextStyle(color: corSecundary, fontSize: 13),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 45,
                          margin: const EdgeInsets.only(right: 7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Image.asset('assets/images/google-icon.png'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: corDivider, width: 2),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 45,
                          margin: const EdgeInsets.only(left: 7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Image.asset(
                            'assets/images/facebook-icon.png',
                            fit: BoxFit.contain,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: corDivider, width: 2),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        push(context, const LoginCadastro(), replace: true);
                      },
                      child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: RichText(
                            text: const TextSpan(
                                text: 'Não tem cadastro? ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Criar conta grátis',
                                      style: TextStyle(
                                          color: corInfo,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700))
                                ]),
                          )),
                    ),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        push(context, const HomePage(), replace: true);
                      },
                      child: const Text(
                        'Entrar no app',
                        style: TextStyle(
                          color: corMuted,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
