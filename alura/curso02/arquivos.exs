defmodule Curso02.Arquivos do
  def ler(arquivo) do
    #File.read retorna tupla com :ok e conteudo ou :error e erro
    #File.read! retorna o conteudo do arquivo ou erro ao ler arquivo
    File.read!(arquivo)
  end
end
