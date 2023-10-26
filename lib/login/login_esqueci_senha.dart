import 'package:flutter/material.dart';
import 'package:projeto_01_teste/login/login_api.dart';
import '../utils/alert.dart';
import '../utils/custom_icons_icons.dart';
import '../utils/navs.dart';
import '../utils/typograph.dart';
import 'login_page.dart';

class EsqueciSenhaPage extends StatefulWidget {
  const EsqueciSenhaPage({Key? key}) : super(key: key);

  @override
  State<EsqueciSenhaPage> createState() => _EsqueciSenhaPageState();
}

class _EsqueciSenhaPageState extends State<EsqueciSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _vEmail = TextEditingController();
  bool showProgress = false;

  String? _validarEmail(String? text) {
    if (text!.isEmpty) {
      return "Digite seu e-mail";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CustomIcons.chevron_left_solid,
              size: 18,
              color: corMuted,
            ),
            onPressed: () {
              push(context, const LoginPage());
            },
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('Entre com a sua conta'),
          elevation: 0.0,
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: const Text(
                      'Esqueceu sua senha ?',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: const Text(
                      'Digite seu E-mail cadastrado para redefinir sua senha',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: corText),
                    ),
                  ),
                  const Text(
                    'E-mail',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        /*  if (_focusSenha != null) {
                            FocusScope.of(context).requestFocus(_focusSenha);
                          }*/
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
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: const Text(
                      'Ao clicar no continuar você receberá no seu e-mail uma nova senha.',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: corMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _recuperarSenha(_vEmail.text);
                alerta(context,
                    "Caso seu e-mail esteja correto e seja o seu e-mail cadastrado, você receberá uma nova senha.\n\n Verifique seu e-mail!",
                    page: const LoginPage());
              });
            }, //_onClickLogin,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showProgress
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'CONTINUAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
              ],
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(corInfo)),
          ),
        ),
      ),
    );
  }

  Future<void> _recuperarSenha(String email) async {
    await LoginApi.recuperarSenha(email);
    return;
  }
}
