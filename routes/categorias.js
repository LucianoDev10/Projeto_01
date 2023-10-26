const express = require('express');
const router = express.Router();
const mysql = require('../mysql').pool;

router.get('/', (req, res, next) => {
    /*res.status(200).send({
        mensagem: 'Retorna todos os prodredsu'
    });*/

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error })
        }
        conn.query(
            'SELECT * FROM categorias;',
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error })
                }
                return res.status(200).send({ response: resultado })
            }
        )
    })

});

//PUXAR CATEGORIA INDIVIDUAL
router.get('/:id', (req, res, next) => {
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


//INSERIR DADOS
router.post('/', (req, res, next) => {
    const categoria = {
        cat_nome: req.body.cat_nome,
        cat_icons: req.body.cat_icons
    };

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error });
        }
        conn.query(
            'INSERT INTO categorias (cat_nome, cat_icons) VALUES (?, ?);',
            [categoria.cat_nome, categoria.cat_icons],
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error });
                }
                categoria.cat_id = resultado.insertId;
                conn.release();
                return res.status(201).send({ message: 'Categoria criada com sucesso', categoria: categoria });
            }
        );
    });
});



// Rota para atualizar uma categoria existente
router.put('/:catId', (req, res, next) => {
    const catId = req.params.catId; // ID da categoria a ser atualizada

    const updatedCategoria = {
        cat_nome: req.body.cat_nome,
        cat_icons: req.body.cat_icons
    };

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error });
        }

        conn.query(
            'UPDATE categorias SET cat_nome = ?, cat_icons = ? WHERE cat_id = ?',
            [updatedCategoria.cat_nome, updatedCategoria.cat_icons, catId],
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error });
                }

                if (resultado.affectedRows === 0) {
                    return res.status(404).send({ message: 'Categoria não encontrada' });
                }

                conn.release();
                return res.status(200).send({ message: 'Categoria atualizada com sucesso' });
            }
        );
    });
});

router.get('/atualizar/:id', (req, res, next) => {
    const idCategoria = req.params.id; // Use "idCategoria" em vez de "categoryId"

    const query = 'SELECT * FROM categorias where cat_id = ?;';

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(query, [idCategoria], (error, resultado, fields) => {
            conn.release(); // Liberar a conexão

            if (error) {
                return res.status(500).json({ error: 'Erro ao executar a consulta' });
            }

            if (resultado.length === 0) {
                return res.status(404).json({ mensagem: 'Nenhum produto encontrado para essa categoria' });
            }
            const categoria = resultado[0]; // Obtenha a primeira categoria encontrada


            return res.status(200).json({ categoria });
        });
    });
});
//DELETAR CATEGORIA
router.delete('/excluir/:id', (req, res, next) => {
    const idCategoria = req.params.id;

    const deleteQuery = 'DELETE FROM categorias WHERE cat_id = ?';

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(deleteQuery, [idCategoria], (error, results, fields) => {
            conn.release();

            if (error) {
                return res.status(500).json({ error: 'Erro ao executar a exclusão' });
            }

            if (results.affectedRows === 0) {
                return res.status(404).json({ mensagem: 'Nenhuma categoria encontrada para exclusão' });
            }

            return res.status(200).json({ mensagem: 'Categoria excluída com sucesso' });
        });
    });
});




module.exports = router;