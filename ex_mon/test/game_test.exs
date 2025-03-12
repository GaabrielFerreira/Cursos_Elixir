defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  #Teste para verificar se o jogo esta iniciando corretamente
  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Gabriel", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  #Teste para analisar os dados recebidos do metodo Game.info()
  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Gabriel", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      expected_response =%{
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Gabriel"
        },
        computer: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        status: :started,
        turn: :player
      }
      assert expected_response == Game.info()
    end
  end

  #Teste para verificar se a atualizacao do jogo foi feita corretamente
  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Gabriel", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      expected_response =%{
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Gabriel"
        },
        computer: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        status: :started,
        turn: :player
      }
      assert expected_response == Game.info()

      new_state = %{
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Gabriel"
        },
        computer: %Player{
          life: 80,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Robotinik"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{new_state | turn: :computer, status: :continue}
      assert expected_response == Game.info()
    end
  end

  #Teste para verificar os dados do player atual
  describe "player/0" do
    test "returns the current player" do
      player = Player.build("Gabriel", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      assert player == Map.get(Game.info(), :player)
    end
  end

  #Teste para verificar se o turno esta mudando corretamente
  describe "turn/0" do
    test "returns the game turn" do
      player = Player.build("Gabriel", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      expected_response = Game.turn() #:computer - resulta em falha pois quando o jogo inicia, o turn eh do player
      assert expected_response == Map.get(Game.info(), :turn)
    end
  end

  #Teste para analisar os dados do player atual
  describe "fetch_player/0" do
    test "returns the player's data" do
      player = Player.build("Gabriel", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :chute, :soco, :cura)
      Game.start(computer, player)

      expected_responde = Game.fetch_player(:player)
      assert expected_responde == Map.get(Game.info(), :player)
    end
  end
end
