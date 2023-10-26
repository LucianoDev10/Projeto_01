import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  final String texto;
  const Titulo({
    required this.texto,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
          fontSize: 22.0,
          color: Colors.black,
          letterSpacing: -1,
          height: 1.2,
          fontWeight: FontWeight.w700),
    );
  }
}
