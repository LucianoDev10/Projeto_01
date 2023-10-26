const express = require('express');
const req = require('express/lib/request');
const router = express.Router();
const mysql = require('../mysql').pool;

//RETORNA TODOS OS PRODUTOS
router.get('/', (req, res, next) => {

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error })
        }
        conn.query(
            'SELECT * FROM produto;',
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error })
                }
                return res.status(200).send({ response: resultado })
            }
        )
    })

});

//RETORNA TODOS OS PRODUTOS
router.get('/melhoresPrecos', (req, res, next) => {

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error })
        }
        conn.query(
            `SELECT p.*
        FROM produto AS p
        INNER JOIN (
          SELECT cat_id, MIN(pro_preco) AS min_preco
          FROM produto
          GROUP BY cat_id
        ) AS sub
        ON p.cat_id = sub.cat_id AND p.pro_preco = sub.min_preco;
        `,
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error })
                }
                return res.status(200).send({ response: resultado })
            }
        )
    })

});

//RETORNA OS DADOS DE UM PRODUTO APENAS
router.get('/:id_produto', (req, res, next) => {
    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error })
        }
        conn.query(
            'SELECT * FROM produto WHERE pro_id = ?;',
            [req.params.id_produto],
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error })
                }
                return res.status(200).send({ response: resultado })
            }
        )
    })
});

router.patch('/', (req, res, next) => {
    mysql.getConnection((error, conn) => {
        conn.query(
            `UPDATE produto
            SET pro_descricao = ?,
            pro_preco = ?,
            pro_qtd = ?
            WHERE produto.pro_id = ?`,
            [req.body.descricao, req.body.preco, req.body.qtd, req.body.id],
            (error, resultado, fields) => {
                conn.release(); // libera a conexão
                if (error) { // verifica se ocorreu algum erro na operação
                    return res.status(500).send({
                        error: error,
                        response: null
                    });
                }
                res.status(202).send({ // envia a resposta de sucesso com o produto criado
                    mensagem: 'Produto atualizado com sucesso',
                    produtoCriado: {
                        id: resultado.insertId,
                        descricao: req.body.descricao,
                        preco: req.body.preco,
                        qtd: req.body.qtd,
                        supermercado_id: req.body.supermercado_id
                    }
                });
            }
        );

    });
});

router.post('/excluirProduto/:pep_id/:ped_id/:pro_id', (req, res, next) => {

    const PedProdutoId = req.params.pep_id;
    const pedidoId = req.params.ped_id;
    const produtoId = req.params.pro_id;

    mysql.getConnection((error, conn) => {
        conn.query(
            `DELETE FROM pedido_produto WHERE pep_id = ? AND ped_id = ? AND pro_id = ?`,
            [PedProdutoId, pedidoId, produtoId], // Use os parâmetros da URL aqui
            (error, resultado, fields) => {
                conn.release(); // libera a conexão
                if (error) { // verifica se ocorreu algum erro na operação
                    return res.status(500).send({
                        error: error,
                        response: null
                    });
                }
                res.status(202).send({ // envia a resposta de sucesso com o produto excluído
                    mensagem: 'Produto excluído com sucesso',
                });
            }
        );

    });
});

//      ------> ADMIN <------

//mostrar os produtos das categorias

router.get('/categorias/:id', (req, res, next) => {
    const idProduto = req.params.id; // Use "idCategoria" em vez de "categoryId"

    const query = 'SELECT * FROM produto where cat_id = ?;';

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(query, [idProduto], (error, resultado, fields) => {
            conn.release(); // Liberar a conexão

            if (error) {
                return res.status(500).json({ error: 'Erro ao executar a consulta' });
            }

            if (resultado.length === 0) {
                return res.status(404).json({ mensagem: 'Nenhum produto encontrado para essa categoria' });
            }
            // Obtenha a primeira categoria encontrada


            return res.status(200).json({ resultado });
        });
    });
});
//INSER UM PRODUTO
router.post('/categorias/:id', (req, res, next) => {
    const idCategoria = req.params.id;

    const produto = {
        pro_descricao: req.body.pro_descricao,
        pro_preco: req.body.pro_preco,
        cat_id: idCategoria,
        pro_foto: req.body.pro_foto,
        pro_subDescricao: req.body.pro_subDescricao,
    };

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error });
        }

        conn.query(
            'INSERT INTO produto (pro_descricao, pro_preco, cat_id, pro_foto, pro_subDescricao) VALUES (?, ?, ?, ?, ?);',
            [produto.pro_descricao, produto.pro_preco, produto.cat_id, produto.pro_foto, produto.pro_subDescricao],
            (error, resultado, fields) => {
                conn.release();

                if (error) {
                    return res.status(500).send({ error: error });
                }

                return res.status(201).send({ message: 'Produto criado com sucesso', produto });
            }
        );
    });
});

//ATUALIZA UM PRODUTO
router.put('/:proId', (req, res, next) => {
    const proId = req.params.proId; // Use "proId" para identificar o produto

    const updatedProduto = {
        pro_descricao: req.body.pro_descricao,
        pro_preco: req.body.pro_preco,
        pro_foto: req.body.pro_foto,
        pro_subDescricao: req.body.pro_subDescricao
    };

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error });
        }

        conn.query(
            'UPDATE produto SET pro_descricao = ?, pro_preco = ?, pro_foto = ?, pro_subDescricao = ? WHERE pro_id = ?',
            [updatedProduto.pro_descricao, updatedProduto.pro_preco, updatedProduto.pro_foto, updatedProduto.pro_subDescricao, proId],
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error });
                }

                if (resultado.affectedRows === 0) {
                    return res.status(404).send({ message: 'Produto não encontrado' });
                }

                conn.release();
                return res.status(200).send({ message: 'Produto atualizado com sucesso' });
            }
        );
    });
});
//MOSTRA UM PRODUTO INDIVIDUAL
router.get('/atualizar/:id', (req, res, next) => {
    const idProduto = req.params.id;

    // Verificar se idProduto é um número válido
    if (isNaN(idProduto)) {
        return res.status(400).json({ error: 'ID de produto inválido' });
    }

    const query = 'SELECT * FROM produto WHERE pro_id = ?;';

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(query, [idProduto], (error, resultado, fields) => {
            conn.release(); // Liberar a conexão

            if (error) {
                return res.status(500).json({ error: 'Erro ao executar a consulta', mysqlError: error });
            }

            if (resultado.length === 0) {
                return res.status(404).json({ mensagem: 'Nenhum produto encontrado para esse ID' });
            }

            const produto = resultado[0]; // Obtenha o primeiro produto encontrado

            return res.status(200).json({ produto });
        });
    });
});


//EXCLUI UM PRODUTO
router.delete('/excluir/:id', (req, res, next) => {
    const idProduto = req.params.id;

    const deleteQuery = 'DELETE FROM produto WHERE pro_id = ?';

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(deleteQuery, [idProduto], (error, results, fields) => {
            conn.release();

            if (error) {
                return res.status(500).json({ error: 'Erro ao executar a exclusão' });
            }

            if (results.affectedRows === 0) {
                return res.status(404).json({ mensagem: 'Nenhuma categoria encontrada para exclusão' });
            }

            return res.status(200).json({ mensagem: 'Produto excluído com sucesso' });
        });
    });
});

//ver dps
router.post('/', (req, res, next) => {

    //console.log(req.file);
    mysql.getConnection((error, conn) => {
        conn.query(
            'INSERT INTO produto (pro_descricao, pro_preco, pro_qtd, Supermercado_sup_id) VALUES (?, ?, ?, ?)',
            [req.body.descricao, req.body.preco, req.body.qtd, req.body.supermercado_id],
            (error, resultado, fields) => {
                conn.release(); // libera a conexão
                if (error) { // verifica se ocorreu algum erro na operação
                    return res.status(500).send({
                        error: error,
                        response: null
                    });
                }

                res.status(201).send({ // envia a resposta de sucesso com o produto criado
                    mensagem: 'Produto inserido com sucesso',
                    produtoCriado: {
                        pro_id: resultado.insertId,
                        descricao: req.body.descricao,
                        preco: req.body.preco,
                        qtd: req.body.qtd,
                        supermercado_id: req.body.supermercado_id
                    }
                });
            }
        );

    });

});

module.exports = router;