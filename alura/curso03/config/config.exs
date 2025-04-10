import Config

config :curso03, Curso03.Agendador, jobs: [
  {"* * * * *", fn -> IO.puts("Executando tarefa agendada") end}
]
