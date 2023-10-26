const axios = require('axios');
const express = require('express');
const router = express.Router();


router.get('/', async (req, res, next) => {
    const { PrimeiroEndereco, SegundoEndereco } = req.body;
    const apiKey = 'AIzaSyC6NFHqVXBsadmvBttMXkwHUd6mngmnaQI'; // Substitua pela sua chave da API do Google Maps

    try {
        const response = await axios.get(
            `https://maps.googleapis.com/maps/api/directions/json?origin=${PrimeiroEndereco}&destination=${SegundoEndereco}&key=${apiKey}`
        );

        if (response.data.status === 'OK' && response.data.routes.length > 0) {
            const route = response.data.routes[0];
            const distance = route.legs[0].distance.text; // Distância em formato de texto, por exemplo, "10.5 km
            const pricePerKm = 2;
            const price = parseFloat(distance) * pricePerKm;
            const mapUrl = `https://www.google.com/maps/dir/?api=1&origin=${PrimeiroEndereco}&destination=${SegundoEndereco}`;

            res.json({ distance, price, mapUrl });
        } else {
            res.status(404).json({ error: 'Rota não encontrada' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Erro ao calcular a rota', details: error.message });
    }
});

module.exports = router;