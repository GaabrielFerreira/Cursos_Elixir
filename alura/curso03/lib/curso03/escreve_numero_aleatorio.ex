defmodule Curso03.EscreveNumeroAleatorio do
  def escreve do
    caminho_arquivo = Path.join([
      :code.priv_dir(:curso03),
      "arquivo.txt"
    ])

    numero_aleatorio = :rand.uniform(1000)
    File.write!(caminho_arquivo, "Numero: #{numero_aleatorio}")
  end
end
