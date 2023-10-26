import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../home_page.dart';
import '../model/usuarios/usuario2_model.dart';
import '../utils/alert.dart';
import '../utils/api_response.dart';
import '../utils/custom_icons_icons.dart';
import '../utils/navs.dart';
import '../utils/typograph.dart';
import 'login_api.dart';
import 'login_page.dart';

class LoginCadastro extends StatefulWidget {
  const LoginCadastro({Key? key}) : super(key: key);

  @override
  State<LoginCadastro> createState() => _LoginCadastroState();
}

class _LoginCadastroState extends State<LoginCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _vNome = TextEditingController();
  final _vEmail = TextEditingController();
  final _vTelefone = TextEditingController();
  final _vEndereco = TextEditingController();
  final _vNumero = TextEditingController();
  final _vSenha = TextEditingController();
  final _vSenha2 = TextEditingController();
  final _focusSenha = FocusNode();
  bool showProgress = false;
  bool _showPassword = false;
  bool _showPassword2 = false;

  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  // validador  de vazio
  String? _validarNome(String? text) {
    if (text!.isEmpty) {
      return "Digite seu Nome Completo";
    }
    if (text.length < 3) {
      return "Digite um nome válido";
    }
    final RegExp nomeRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    if (nomeRegExp.hasMatch(text) != false) {
      return "Entre com um nome válido";
    }
    return null;
  }

  String? _validarTelefone(String? text) {
    if (text!.isEmpty) {
      return "Digite seu telefone";
    }
    if (text.length <= 13) {
      return "Digite um telefone válido";
    }

    return null;
  }

  String? _validarEmail(String? text) {
    if (text!.isEmpty) {
      return "Digite seu e-mail";
    }
    final bool isValid = EmailValidator.validate(text);
    if (isValid == false) {
      return "E-mail inválido";
    }
    return null;
  }

  String? _validarSenha(String? text) {
    if (text!.isEmpty) {
      return "Digite a senha";
    }
    if (text.length <= 6) {
      return "A senha precisa ter ao menos 7 caracteres";
    }
    return null;
  }

  String? _validarSenha2(String? text) {
    if (_vSenha.text != text) {
      return "As senhas não conferem";
    }
    return null;
  }

  _body() {
    return Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: const Text(
                    'Cadastrar',
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
                    controller: _vNome,
                    validator: _validarNome,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: const Icon(
                        CustomIcons.user,
                        size: 20,
                      ),
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: corFundoLogin),
                      filled: true,
                      fillColor: Color(int.parse("0xffF4F4F4")),
                      hintText: 'Seu nome completo',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _vTelefone,
                    validator: _validarTelefone,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      phoneFormatter
                      //TelefoneInputFormatter(),
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: corFundoLogin),
                      filled: true,
                      fillColor: Color(int.parse("0xffF4F4F4")),
                      hintText: 'Seu telefone',
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
                      hintText: 'Email',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                        child: TextFormField(
                          controller: _vEndereco,
                          validator: _validarNome,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            prefixIcon: const Icon(
                              CustomIcons.location_dot,
                              size: 20,
                            ),
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: corFundoLogin),
                            filled: true,
                            fillColor: Color(int.parse("0xffF4F4F4")),
                            hintText: 'Seu endereço',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 8, bottom: 8, left: 4),
                        child: TextFormField(
                          controller: _vNumero,
                          validator: _validarNome,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: corFundoLogin),
                            filled: true,
                            fillColor: Color(int.parse("0xffF4F4F4")),
                            hintText: 'N°',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _vSenha,
                    validator: _validarSenha,
                    focusNode: _focusSenha,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: const Icon(
                        CustomIcons.lock_keyhole,
                        size: 20,
                      ),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _showPassword == false
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
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: corFundoLogin),
                      filled: true,
                      fillColor: Color(int.parse("0xffF4F4F4")),
                      hintText: 'Senha',
                    ),
                    obscureText: _showPassword == false ? true : false,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _vSenha2,
                    validator: _validarSenha2,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: const Icon(
                        CustomIcons.lock_keyhole,
                        size: 20,
                      ),
                      suffixIcon: GestureDetector(
                        child: Icon(
                          _showPassword2 == false
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          setState(() {
                            _showPassword2 = !_showPassword2;
                          });
                        },
                      ),
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: corFundoLogin),
                      filled: true,
                      fillColor: Color(int.parse("0xffF4F4F4")),
                      hintText: 'Confirme a Senha',
                    ),
                    obscureText: _showPassword2 == false ? true : false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cadastrar,
                    child: const Text(
                      'AVANÇAR',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(corInfo)),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      push(context, const LoginPage(), replace: true);
                    },
                    child: RichText(
                      text: const TextSpan(
                          text: 'Já tem cadastro? ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Entre agora',
                                style: TextStyle(
                                    color: corInfo,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700))
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _cadastrar() async {
    Usuario2 usuario = Usuario2(
      nome: _vNome.text,
      email: _vEmail.text,
      endereco: _vEndereco.text,
      numero: _vEndereco.text,
      telefone: _vTelefone.text,
      senha: _vSenha.text,
    );
    ApiResponse<bool> response = await LoginApi.cadastrar(usuario);

    if (response.ok) {
      push(context, const HomePage());
    } else {
      alerta(context, response.msg);
    }
  }
}
