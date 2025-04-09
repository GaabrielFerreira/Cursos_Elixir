defmodule Curso03.Aplicacao do
  use Application

  def start(_type, _ags) do
    children = [
      Curso03.Agendador
    ]

    opts =[
      strategy: :one_for_one,
      name: Curso03.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
