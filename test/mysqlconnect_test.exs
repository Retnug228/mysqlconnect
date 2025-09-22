defmodule MysqlconnectTest do
  use ExUnit.Case
  doctest Mysqlconnect

  test "greets the world" do
    assert Mysqlconnect.hello() == :world
  end
end
