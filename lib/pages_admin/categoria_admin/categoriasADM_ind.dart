import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages_admin/categoria_admin/categoriasADM_api.dart';

import '../../model/categorias/categorias_modal.dart';

class CategoriaADMind extends StatefulWidget {
  final Categorias? categoria; // Adicione o parâmetro para receber a categoria
  CategoriaADMind({this.categoria});

  @override
  _CategoriaADMindState createState() => _CategoriaADMindState();
}

class _CategoriaADMindState extends State<CategoriaADMind> {
  final TextEditingController _nomeCategoriaController =
      TextEditingController();
  final TextEditingController _catIconsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _atualizarCategoriaData();

    /* if (widget.categoria != null) {
      _nomeCategoriaController.text = widget.categoria!.cat_nome ?? '';
      _catIconsController.text = widget.categoria!.cat_icons ?? '';
    }*/
  }

  Future<void> _atualizarCategoriaData() async {
    // declarando o parametro
    final categoriaService = categoriasADMapi();

    if (widget.categoria != null) {
      final categoriaId =
          widget.categoria!.cat_id; // ID da categoria a ser buscada
      final categoriaAtualizada =
          await categoriaService.getDetalhesCategoria(categoriaId!);

      if (categoriaAtualizada != null) {
        setState(() {
          _nomeCategoriaController.text = categoriaAtualizada.cat_nome ?? '';
          _catIconsController.text = categoriaAtualizada.cat_icons ?? '';
        });
      }
    }
  }

  Future<void> _atualizarCategoria() async {
    String catNome = _nomeCategoriaController.text;
    String catIcons = _catIconsController.text;
    final bool? response;

    if (widget.categoria != null) {
      response = await categoriasADMapi.atualizarCategoria(
        widget.categoria!.cat_id!,
        catNome,
        catIcons,
      );
    } else {
      response = await categoriasADMapi.criarCategoria(catNome, catIcons);
    }

    if (response == true) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Categoria atualizada com sucesso'),
            content: const Text('Clique em OK para voltar à página anterior.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar a categoria'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeCategoriaController,
              decoration: const InputDecoration(
                labelText: 'Nome da Categoria',
              ),
            ),
            TextField(
              controller: _catIconsController,
              decoration: const InputDecoration(
                labelText: 'Ícone da Categoria',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _atualizarCategoria, // Atualize o nome da função aqui
              child: Text('Salvar Categoria'),
            ),
          ],
        ),
      ),
    );
  }
}
