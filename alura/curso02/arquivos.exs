defmodule Curso02.Arquivos do
  def ler(arquivo) do
    #File.read retorna tupla com :ok e conteudo ou :error e erro
    #File.read! retorna o conteudo do arquivo ou erro ao ler arquivo
     case File.read(arquivo) do
       {:ok, conteudo} -> IO.puts(conteudo)
       {:error, :enoent} -> "Arquivo inexistente"
       {:error, :eacces} -> "Arquivo sem permissao de leitura"
       _ -> "Erro desconhecido"
     end
  end
end
