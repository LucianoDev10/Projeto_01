const express = require('express');
const req = require('express/lib/request');
const { poolPromise } = require('../mysql');
const router = express.Router();
const mysql = require('../mysql').pool;
const mysqlPromise = require('../mysql').poolPromise;


///------------------ ADMIN

/// get all
router.get('/', (req, res, next) => {

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error })
        }
        conn.query(
            'SELECT * FROM entrega;',
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error })
                }
                return res.status(200).send({ response: resultado })
            }
        )
    })

});

// ROTA PARA VISUALIZAR OS DADOS DETALHADOS
router.post('/pedidosInd/:ped_id', async (req, res) => {
    const pedidoProdutoId = req.params.ped_id;
    let status;
    const connection = await poolPromise.getConnection();

    const queryConsultarPedido = `
    SELECT p.pro_id, pp.pep_id, p.pro_descricao, p.pro_preco, pp.pep_frete, p.pro_foto FROM pedido_produto pp
    INNER JOIN pedidos pd ON pp.ped_id = pd.ped_id
    INNER JOIN produto p ON pp.pro_id = p.pro_id
    WHERE pd.ped_id = ?`;

    const [resultadoConsulta] = await connection.execute(queryConsultarPedido, [pedidoProdutoId]);

    //console.log(resultadoConsulta);


    if (resultadoConsulta.length === 0) {
        status = 404;
        return res.status(status).json({ mensagem: "Pedido individual não encontrado" });
    }

    const pedido = resultadoConsulta;
    status = 200;

    connection.release(); // Liberar a conexão após a consulta
    res.status(status).json({ pedido });

});


router.post('/Encerrado/:ped_id', async (req, res) => {
    const pedidoId = req.params.ped_id;
    const connection = await poolPromise.getConnection();


    // Verificar se o pedido com o ID fornecido está em andamento
    const queryVerificarPedido = 'SELECT * FROM entrega WHERE ped_id = ?';

    try {
        const [resultados] = await connection.execute(queryVerificarPedido, [pedidoId]);

        let mensagem;
        let status;
        let pedido;
        const dataHoraFormatada = new Date().toISOString().slice(0, 19).replace('T', ' ');

        if (resultados.length > 0) {
            const pedidoAtual = resultados[0];

            if (pedidoAtual.ent_status_admin === 'Pendente') {
                const queryAtualizarPedido = 'UPDATE entrega SET ent_status_admin = ? WHERE ped_id = ?';
                await connection.execute(queryAtualizarPedido, ['Aceito', pedidoId]);


                status = 200;
                pedido = { ped_id: pedidoId, ent_status_admin: 'Aceito' };
                mensagem = 'Entrega feita com sucesso';

            } else if (pedidoAtual.ent_status_admin === 'Aceito') {
                mensagem = 'A entrega já foi aceita';
                status = 400;
            }
        } else {
            mensagem = 'Não foi encontrado nenhum entrega com o ID fornecido ou o entrega já está encerrado';
            status = 400;
        }

        connection.release(); // Liberar a conexão após a consulta

        res.status(status).json({ mensagem, pedido });
    } catch (error) {
        console.error('Erro na requisição: ', error);
        res.status(500).json({ mensagem: 'Erro interno do servidor', pedido: null });
    }
});


///------------------ ENTREGADOR

// PEDIDO SÓ APARECE PARA SER ACEITO CASO O ADMIN ACEITAR
router.get('/entregador', (req, res, next) => {

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error })
        }
        conn.query(
            `SELECT * FROM entrega  WHERE  ent_status_admin = 'Aceito'; `,
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error })
                }
                return res.status(200).send({ response: resultado })
            }
        )
    })
});

//INSERIR DADOS DE ACEITAR O PEDIDO E QUANTO TEMPO VAI LEVAR
router.post('/entregas/:ped_id/:usu_id/:ent_minutos', async (req, res) => {
    const pedidoId = req.params.ped_id;
    const usuarioId = req.params.usu_id;
    const minutos = req.params.ent_minutos;
    const connection = await poolPromise.getConnection();


    // Verificar se o pedido com o ID fornecido está em andamento
    const queryVerificarPedido = 'SELECT * FROM entrega WHERE ped_id = ?';

    try {
        const [resultados] = await connection.execute(queryVerificarPedido, [pedidoId]);

        let mensagem;
        let status;
        let pedido;

        if (resultados.length > 0) {
            const pedidoAtual = resultados[0];

            if (pedidoAtual.ent_status_entregador === 'Pendente') {
                const queryAtualizarPedido = 'UPDATE entrega SET ent_status_entregador = ? ,usu_id = ?, ent_minutos = ? WHERE ped_id = ?';
                await connection.execute(queryAtualizarPedido, ['Aceito', usuarioId, minutos, pedidoId]);


                status = 200;
                pedido = { ped_id: pedidoId, ent_status_entregador: 'Aceito' };
                mensagem = 'Entrega aceita com sucesso';

            } else if (pedidoAtual.ent_status_entregador === 'Aceito') {
                mensagem = 'A entrega já foi aceita';
                status = 400;
            }
        } else {
            mensagem = 'Não foi encontrado nenhum entrega com o ID fornecido ou o entrega já está encerrado';
            status = 400;
        }

        connection.release(); // Liberar a conexão após a consulta

        res.status(status).json({ mensagem, pedido });
    } catch (error) {
        console.error('Erro na requisição: ', error);
        res.status(500).json({ mensagem: 'Erro interno do servidor', pedido: null });
    }
});

// ENTREGAS REALIZADAS
router.post('/entregas/realizada/:ped_id', async (req, res) => {
    const pedidoId = req.params.ped_id;
    const connection = await poolPromise.getConnection();


    // Verificar se o pedido com o ID fornecido está em andamento
    const queryVerificarPedido = 'SELECT * FROM entrega WHERE ped_id = ?';

    try {
        const [resultados] = await connection.execute(queryVerificarPedido, [pedidoId]);

        let mensagem;
        let status;
        let pedido;

        if (resultados.length > 0) {
            const pedidoAtual = resultados[0];

            if (pedidoAtual.ent_status_admin === 'Aceito') {
                const queryAtualizarPedido = 'UPDATE entrega SET ent_status_admin = ? WHERE ped_id = ?';
                await connection.execute(queryAtualizarPedido, ['Entregue', pedidoId]);


                status = 200;
                pedido = { ped_id: pedidoId, ent_status_admin: 'Entregue' };
                mensagem = 'Entrega feita com sucesso';

            } else if (pedidoAtual.ent_status_admin === 'Entregue') {
                mensagem = 'A entrega foi realizada';
                status = 400;
            }
        } else {
            mensagem = 'Não foi encontrado nenhum entrega com o ID fornecido ou o entrega já está encerrado';
            status = 400;
        }

        connection.release(); // Liberar a conexão após a consulta

        res.status(status).json({ mensagem, pedido });
    } catch (error) {
        console.error('Erro na requisição: ', error);
        res.status(500).json({ mensagem: 'Erro interno do servidor', pedido: null });
    }
});

// VALOR TOTAL DE ENTREGAS
router.get('/entregador/ValorTotal/:usu_id', (req, res, next) => {
    const usu_id = req.params.usu_id;

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).send({ error: error });
        }
        conn.query(
            `SELECT
            e.*,
            SUM(e.ent_valor_frete) AS valor_total
        FROM entrega AS e
        INNER JOIN pedidos AS p ON e.ped_id = p.ped_id
        WHERE e.usu_id = ? and e.ent_status_entregador = 'Entregue'`,
            [usu_id], // Passa o valor de usu_id como parâmetro
            (error, resultado, fields) => {
                if (error) {
                    return res.status(500).send({ error: error });
                }
                return res.status(200).send({ response: resultado });
            }
        );
    });
});


//PEDIDOS REALIZADOS PELO ENTREGADOR
router.get('/entregas/:id', (req, res, next) => {
    const usuId = req.params.id;

    const query = `SELECT * entrega where usu_id = ? and ent_status_entregador = 'Entregue';`;

    mysql.getConnection((error, conn) => {
        if (error) {
            return res.status(500).json({ error: 'Erro ao conectar ao banco de dados' });
        }

        conn.query(query, [usuId], (error, resultado, fields) => {
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
module.exports = router;