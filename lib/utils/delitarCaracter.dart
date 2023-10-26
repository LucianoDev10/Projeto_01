String limitarTexto(String texto, int limiteCaracteres) {
  if (texto.length <= limiteCaracteres) {
    return texto;
  } else {
    return texto.substring(0, limiteCaracteres) +
        '...'; // Adiciona reticências (...) no final do texto cortado
  }
}
