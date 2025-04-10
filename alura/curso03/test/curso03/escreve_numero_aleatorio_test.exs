defmodule Curso03.EscreveNumeroAleatorioTest do
  use ExUnit.Case
  import Mock

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

  test "2 escritas ..., com mock" do
    :ets.new(:conteudos, [:set, :private, :named_table])
    with_mock File, [write!: fn (_path, conteudo) -> :ets.insert_new(:conteudos, {conteudo})end] do
      Curso03.EscreveNumeroAleatorio.escreve()
      Curso03.EscreveNumeroAleatorio.escreve()
    end

    conteudos = :ets.tab2list(:conteudos)
    [primeiro_valor | conteudos] = conteudos
    [segundo_valor | _] = conteudos

    assert primeiro_valor != segundo_valor
  end
end
