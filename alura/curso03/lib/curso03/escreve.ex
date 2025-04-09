defmodule Mix.Tasks.Escreve do
  @moduledoc """
  Documentacao completa da tarefa (em mix help)

  `mix escreve`
  """
  use Mix.Task
  @shortdoc "Escreve um numero aleatorio no arquivo.txt"

  def run(_) do
    Curso03.EscreveNumeroAleatorio.escreve()
  end
end
