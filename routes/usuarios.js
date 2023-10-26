const express = require('express');
const router = express.Router();
const mysql = require('../mysql').pool;
const bcrypt = require('bcrypt');
//const mysql = require('mysql');
const jwt = require('jsonwebtoken');


router.post('/cadastro', (req, res, next) => {

    mysql.getConnection((error, conn) => {
        if (error) { return res.status(500).send({ error: error }) }
        conn.query('SELECT * FROM usuario WHERE usu_email = ?', [req.body.email], (error, resultado) => {
            if (error) { return res.status(500).send({ error: error }) }
            if (resultado.length > 0) {
                res.status(409).send({ mensagem: 'Usuario já cadastrado' })
            }
            else {
                bcrypt.hash(req.body.senha, 10, (errBcrypt, hash) => {
                    if (errBcrypt) { return res.status(500).send({ error: errBcrypt }) }

                    conn.query('INSERT INTO usuario (usu_nome, usu_email, usu_telefone, usu_senha) VALUES (?, ?, ?, ?)',
                        [req.body.nome, req.body.email, req.body.telefone, hash],
                        (error, resultado) => {
                            conn.release();

                            if (error) { return res.status(500).send({ error: error }) }
                            response = {
                                mensagem: 'Usuario criado com sucesso',
                                usuarioCriado: {
                                    usu_id: resultado.insertId,
                                    nome: req.body.nome,
                                    email: req.body.email,
                                    telefone: req.body.telefone,
                                }
                            }
                            return res.status(201).send(response);
                        }
                    );
                })
            }

        })


    })
});



router.post('/login', (req, res, next) => {
    mysql.getConnection((error, conn) => {
        if (error) { return res.status(500).send({ error: error }) }
        const query = 'SELECT * FROM usuario WHERE usu_email = ?';
        conn.query(query, [req.body.email], (error, resultado, fields) => {
            conn.release();
            if (error) { return res.status(500).send({ error: error }) }
            if (resultado.length < 1) {
                return res.status(401).send({ mensagem: 'Email não existe' })
            }


            const usuario = resultado[0];

            //const senhaValida = bcrypt.compare(req.body.senha, usuario.senha);
            return res.status(200).send({
                mensagem: 'Autenticado com sucesso', usuario: usuario, // Retorna os detalhes do usuário
            });
            /*if (senhaValida) {
                // const token = jwt.sign({ email: usuario.email }, process.env.JWT_KEY, { expiresIn: '7d' });

            }
            if (res.status(400)) {
                print("erro no email ou na senha")
            }
            return res.status(401).send({ mensagem: 'Falha na autenticação' })*/
        })
    })
});

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

// retorna os dados
router.get('/getUsers/:id', (req, res) => {
    const idCategoria = req.params.id;

    const query = 'SELECT * FROM usuario where usu_id = ?;';

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(query, [idCategoria], (error, resultado, fields) => {
            conn.release();

            if (error) {
                return res.status(500).json({ error: 'Erro ao executar a consulta' });
            }

            if (resultado.length === 0) {
                return res.status(404).json({ mensagem: 'Nenhum usuário encontrado' });
            }

            return res.status(200).json(resultado[0]); // Retorna o primeiro usuário encontrado
        });
    });
});


//atualizar o usuario

router.post('/atualizarUsuario/:usu_id', (req, res) => {
    const usuarioId = req.params.usu_id;
    const { usuNome, usuEmail, usuCpf, usuTelefone, usuEndereco, usuNumero, usuCep } = req.body;

    // Obtenha uma conexão do pool de conexões
    mysql.getConnection((err, conn) => {
        if (err) {
            console.error('Erro ao obter conexão do pool: ' + err.stack);
            return res.status(500).json({ error: 'Erro interno do servidor' });
        }

        // Atualize o usuário no banco de dados
        const sql = 'UPDATE usuario SET usu_nome = ?, usu_email = ?, usu_cpf = ?, usu_telefone = ?, usu_endereco = ?, usu_numero = ?, usu_cep = ? WHERE usu_id = ?';
        conn.query(sql, [usuNome, usuEmail, usuCpf, usuTelefone, usuEndereco, usuNumero, usuCep, usuarioId], (err, result) => {
            conn.release();
            if (err) {
                console.error('Erro ao atualizar o usuário: ' + err.stack);
                return res.status(500).json({ error: 'Erro interno do servidor' });
            }
            res.status(200).json({
                message: 'Usuário atualizado com sucesso', updatedValues: {
                    usuNome: usuNome,
                    usuEmail: usuEmail,
                    usuCpf: usuCpf,
                    usuTelefone: usuTelefone,
                    usuEndereco: usuEndereco,
                    usuNumero: usuNumero,
                    usuCep: usuCep,
                    usuarioId: usuarioId
                }
            });
        });
    });
});



module.exports = router;