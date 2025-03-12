defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Player
  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Gabriel"
      }

      assert expected_response == ExMon.create_player("Gabriel", :chute, :soco, :cura)
    end
  end

  #Verifica se o jogo esta iniciando corretamente
  describe "start_game/1" do
    test "when the game is started, returns a message" do
      player = Player.build("Gabriel", :chute, :soco, :cura)

      #Uso do metodo capture_io para receber a saida do metodo (:ok) e receber a string em messages
      messages = capture_io(fn ->
        assert ExMon.start_game(player) == :ok
      end)

      #Verifica se as mensagens abaixo estao presentes na saida da funcao start_game, utilizando o =~
      assert messages =~ "The game is started"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  #Teste para verificar se o movimento eh valido ou nao
  describe "make_move/1" do
    #Cria o setup para usar nos dois testes (TODO CODIGO DO SETUP EXECUTA ANTES DOS TESTES)
    setup do
      player = Player.build("Gabriel", :chute, :soco, :cura)

      capture_io(fn ->
        ExMon.start_game(player) #start_game dentro do capture_io

      end)

      {:ok, player: player} #Espera que devolva sucesso ou uma variavel
    end

    test "when the move is valid, do the move and the computer makes a move" do
      messages = capture_io(fn ->
        ExMon.make_move(:chute)
      end)

      assert messages =~ "The Player attacked the computer"
      assert messages =~ "It's computer turn"
      assert messages =~ "It's player turn"
      assert messages =~ "status: :continue"
    end

    test "when the move is invalid, returns an error message" do
      messages = capture_io(fn ->
        ExMon.make_move(:wrong)
      end)

      assert messages =~  "Invalid move: wrong"
    end
  end
end
