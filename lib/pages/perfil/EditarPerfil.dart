import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto_01_teste/model/usuarios/usuario2_model.dart';
import '../../../utils/alert.dart';
import '../../../utils/api_response.dart';
import '../../../utils/custom_icons_icons.dart';
import '../../../utils/typograph.dart';
import 'editarperfi_api.dart';

class EditarPerfilPage extends StatefulWidget {
  EditarPerfilPage({Key? key}) : super(key: key);

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _vNome = TextEditingController();
  final _vEmail = TextEditingController();
  final _vTelefone = TextEditingController();
  final _vCpf = TextEditingController();
  final _vEndereco = TextEditingController();
  final _vNumero = TextEditingController();
  final _vCep = TextEditingController();

  final _vSenha = TextEditingController();
  final _focusSenha = FocusNode();
  bool showProgress = false;
  bool _showPassword = false;
  bool _showPassword2 = false;

  void _mostrarMensagem(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensagem'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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

  String? validarCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return 'Digite um CPF válido';
    }

    // Remove todos os caracteres não numéricos
    final cpfNumerico = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se o CPF possui 11 dígitos
    if (cpfNumerico.length != 11) {
      return 'CPF deve conter 11 dígitos';
    }

    // Calcula o dígito verificador do CPF
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpfNumerico[i]) * (10 - i);
    }
    int resto = soma % 11;
    int primeiroDigitoVerificador = resto < 2 ? 0 : 11 - resto;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpfNumerico[i]) * (11 - i);
    }
    resto = soma % 11;
    int segundoDigitoVerificador = resto < 2 ? 0 : 11 - resto;

    // Verifica se os dígitos verificadores são válidos
    if (int.parse(cpfNumerico[9]) != primeiroDigitoVerificador ||
        int.parse(cpfNumerico[10]) != segundoDigitoVerificador) {
      return 'CPF inválido';
    }

    return null; // CPF válido
  }

  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    carregarUsuario(); // Chama a função para carregar o usuário
  }

  Future<Usuario2> carregarUsuario() async {
    Usuario2 usuario = await EditarPerfilApi.getUsuario();

    _vNome.text = usuario.nome!;
    _vEmail.text = usuario.email!;
    _vTelefone.text = usuario.telefone!;
    _vCpf.text = usuario.cpf!;
    _vEndereco.text = usuario.endereco!;
    _vNumero.text = usuario.numero!;
    _vCep.text = usuario.cep!;

    return usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: const Text(
          "Editar",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Usuario2>(
          future: carregarUsuario(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                padding: const EdgeInsets.all(30),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            Usuario2 usuario = snapshot.data!;

            return Form(
              key: _formKey,
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                  children: [
                    const Text(
                      'Nome',
                      style: TextStyle(color: corTxtLogin, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 2),
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

                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Telefone',
                      style: TextStyle(color: corTxtLogin, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: TextFormField(
                        controller: _vTelefone,
                        validator: _validarTelefone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          phoneFormatter,
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

                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(color: corTxtLogin, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: TextFormField(
                        onFieldSubmitted: (String text) {
                          /*   if (_focusSenha != null) {
                          FocusScope.of(context).requestFocus(_focusSenha);
                        }*/
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

                    // PROXIMO INPUT
                    const Text(
                      'Cpf',
                      style: TextStyle(color: corTxtLogin, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: TextFormField(
                        onFieldSubmitted: (String text) {},
                        validator: validarCPF,
                        controller: _vCpf,
                        keyboardType: TextInputType.number,
                        inputFormatters: [cpfFormatter],
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
                          hintText: 'Cpf',
                        ),
                      ),
                    ),
                    const Text(
                      'Cep',
                      style: TextStyle(color: corTxtLogin, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: TextFormField(
                        controller: _vCep,
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
                          hintText: 'Cep',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2, // Peso maior para o campo de endereço
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Endereço',
                                style:
                                    TextStyle(color: corTxtLogin, fontSize: 16),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: TextFormField(
                                  onFieldSubmitted: (String text) {
                                    // Se desejar adicionar alguma ação quando o campo for submetido
                                  },
                                  controller: _vEndereco,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: corFundoLogin,
                                    ),
                                    prefixIcon: const Icon(
                                      CustomIcons.house,
                                      size: 20,
                                    ),
                                    filled: true,
                                    fillColor: Color(int.parse("0xffF4F4F4")),
                                    hintText: 'Endereço',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            width: 16), // Espaçamento entre os campos
                        Expanded(
                          flex: 1, // Peso menor para o campo de número
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Número',
                                style:
                                    TextStyle(color: corTxtLogin, fontSize: 16),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: TextFormField(
                                  controller: _vNumero,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(12),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: corFundoLogin,
                                    ),
                                    filled: true,
                                    fillColor: Color(int.parse("0xffF4F4F4")),
                                    hintText: 'Número',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 36, 0, 0),
                      height: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          bool formOk = _formKey.currentState!.validate();
                          if (!formOk) {
                            return; //aborta
                          }

                          setState(() {
                            Usuario2 usuario = Usuario2(
                              nome: _vNome.text,
                              email: _vEmail.text,
                              telefone: _vTelefone.text,
                              cpf: _vCpf.text,
                              endereco: _vEndereco.text,
                              numero: _vNumero.text,
                              cep: _vCep.text,
                            );

                            _cadastrar(usuario);
                          });
                        },
                        child: const Text(
                          'SALVAR',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(corInfo)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> _cadastrar(
    Usuario2 user,
  ) async {
    ApiResponse<bool> response = await EditarPerfilApi.saveUsuario(user);

    if (response.ok) {
      _mostrarMensagem('Cadastro realizado com sucesso!');
    } else {
      alerta(context, response.msg);
    }
  }
}
