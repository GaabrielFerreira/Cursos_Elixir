defmodule Curso03.EscreveNumeroAleatorioTest do
  use ExUnit.Case

  test "2 escritas no arquivo geram numeros diferentes" do
    Curso03.EscreveNumeroAleatorio.escreve()

    primeiro_conteudo = File.read!(Path.join([
      :code.priv_dir(:curso03),
      "arquivo.txt"
    ]))

    Curso03.EscreveNumeroAleatorio.escreve()

    segundo_conteudo = File.read!(Path.join([
      :code.priv_dir(:curso03),
      "arquivo.txt"
    ]))

    assert primeiro_conteudo != segundo_conteudo
  end
end
