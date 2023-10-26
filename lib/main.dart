import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto_01_teste/pages/pedidos/pedidos_bloc.dart';
import 'package:projeto_01_teste/utils/my_http_overrides.dart';
import 'package:provider/provider.dart';
import 'login/login_page.dart';
import 'utils/typograph.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  final pedidosBloc = PedidosBloc(); // Cria uma única instância
  runApp(AppGuiaTaubate(pedidosBloc: pedidosBloc));
}

class AppGuiaTaubate extends StatelessWidget {
  final PedidosBloc pedidosBloc; // Campo pedidosBloc

  const AppGuiaTaubate({Key? key, required this.pedidosBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [], // Compartilha a instância do PedidosBloc
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Go Market',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          scaffoldBackgroundColor: const Color(0xffDFE7EB),
          appBarTheme: const AppBarTheme(
            elevation: 1,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: corText),
            titleTextStyle: TextStyle(
              color: corText,
            ),
            titleSpacing: 0,
            centerTitle: false,
          ),
        ),
        themeMode: ThemeMode.light,
        home: LoginPage(),
      ),
    );
  }
}
