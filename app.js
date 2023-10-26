//bibliotecas
const express = require('express');
const app = express();
const morgan = require('morgan');
const bodyParser = require('body-parser');
const cors = require('cors'); // Importe o pacote cors
const rotaProdutos = require('./routes/produtos');
const rotaPedidos = require('./routes/pedidos');
const rotaUsuarios = require('./routes/usuarios');
const rotaSupermercados = require('./routes/categorias');
const rotaEntregas = require('./routes/entregas');
const rotaFrete = require('./routes/calculeFrete');



const req = require('express/lib/request');

app.use(morgan('dev'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(cors());

app.use('/produtos', rotaProdutos);
app.use('/pedidos', rotaPedidos);
app.use('/usuarios', rotaUsuarios);
app.use('/categorias', rotaSupermercados);
app.use('/entregas', rotaEntregas);
app.use('/frete', rotaFrete);



// quando nao encontra a rota entra aqui
app.use((req, res, next) => {
    const erro = new Error('Não encontrado');
    erro.status = 404;
    next(erro);
});

app.use((error, req, res, next) => {
    res.status(error.status || 500);
    return res.send({
        erro: {
            mensagem: error.mensagem
        }
    });
});


module.exports = app;