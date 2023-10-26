import 'package:flutter/material.dart';
import 'package:projeto_01_teste/pages_admin/produtos_admin/produtosADM_api.dart';

class ProdutoADMind extends StatefulWidget {
  final int catId;
  final int? proId;

  ProdutoADMind({Key? key, required this.catId, this.proId}) : super(key: key);

  @override
  _ProdutoADMindState createState() => _ProdutoADMindState(catId, proId);
}

class _ProdutoADMindState extends State<ProdutoADMind> {
  final int catId;
  final int? proId;
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _fotoController = TextEditingController();
  final TextEditingController _subDescricaoController = TextEditingController();

  _ProdutoADMindState(this.catId, this.proId);

  @override
  void initState() {
    super.initState();
    _atualizarProdutoData();
  }

  Future<void> _atualizarProdutoData() async {
    final produtoService = produtosADMapi();

    if (widget.proId != null) {
      final produtoId = widget.proId;
      final produtoAtualizado =
          await produtoService.getDetalhesProduto(produtoId!);

      if (produtoAtualizado != null) {
        setState(() {
          _descricaoController.text = produtoAtualizado.pro_descricao ?? '';
          _precoController.text = produtoAtualizado.pro_preco.toString() ?? '';
          _fotoController.text = produtoAtualizado.pro_foto ?? '';
          _subDescricaoController.text =
              produtoAtualizado.pro_subDescricao ?? '';
        });
      }
    }
  }

  Future<void> _atualizarProduto() async {
    String descricao = _descricaoController.text;
    String preco = _precoController.text;
    String foto = _fotoController.text;
    String subDescricao = _subDescricaoController.text;

    final bool? response;

    if (widget.proId != null) {
      response = await produtosADMapi.atualizarProduto(
          widget.proId!, descricao, double.parse(preco), foto, subDescricao);
    } else {
      response = await produtosADMapi.criarProduto(
          widget.catId, descricao, double.parse(preco), foto, subDescricao);
    }

    if (response == true) {
      print('TESTESSS');
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível atualizar o produto'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar/Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição do Produto',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço do Produto',
              ),
            ),
            TextField(
              controller: _fotoController,
              decoration: const InputDecoration(
                labelText: 'URL da Foto',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _subDescricaoController,
              decoration: const InputDecoration(
                labelText: 'Subdescrição do Produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _atualizarProduto,
              child: Text('Salvar Produto'),
            ),
          ],
        ),
      ),
    );
  }
}
