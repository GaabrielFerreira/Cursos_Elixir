defmodule Curso03Test do
  use ExUnit.Case
  doctest Curso03

  test "greets the world" do
    assert Curso03.hello() == :world
  end
end
