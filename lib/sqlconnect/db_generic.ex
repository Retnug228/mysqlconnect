defmodule SQLconnect.DBGeneric do


  @db_config [
    hostname: "localhost",
    username: "root",
    password: "pass",
    database: "test_db"
  ]


  defp connect do
    {:ok, pid} = MyXQL.start_link(@db_config)
    pid
  end


  def create_table(table_name, columns) when is_binary(table_name) and is_list(columns) do
    pid = connect()

    columns_sql =
      columns
      |> Enum.map(fn {name, type} -> "#{name} #{type}" end)
      |> Enum.join(", ")

    sql = "CREATE TABLE IF NOT EXISTS #{table_name} (#{columns_sql});"
    MyXQL.query(pid, sql)
  end


  def insert(table_name, values) when is_binary(table_name) and is_map(values) do
    pid = connect()

    columns = Map.keys(values) |> Enum.join(", ")
    placeholders = Enum.map(values, fn _ -> "?" end) |> Enum.join(", ")
    sql = "INSERT INTO #{table_name} (#{columns}) VALUES (#{placeholders});"
    MyXQL.query(pid, sql, Map.values(values))
  end


  def all(table_name) when is_binary(table_name) do
    pid = connect()
    sql = "SELECT * FROM #{table_name};"
    {:ok, result} = MyXQL.query(pid, sql)
    result.rows
  end


  def get(table_name, id) when is_binary(table_name) do
    pid = connect()
    sql = "SELECT * FROM #{table_name} WHERE id = ?;"
    {:ok, result} = MyXQL.query(pid, sql, [id])
    case result.rows do
      [] -> nil
      [row] -> row
    end
  end


  def update(table_name, id, values) when is_binary(table_name) and is_map(values) do
    pid = connect()
    set_sql =
      values
      |> Enum.map(fn {col, _} -> "#{col} = ?" end)
      |> Enum.join(", ")

    sql = "UPDATE #{table_name} SET #{set_sql} WHERE id = ?;"
    MyXQL.query(pid, sql, Map.values(values) ++ [id])
  end


  def delete(table_name, id) when is_binary(table_name) do
    pid = connect()
    sql = "DELETE FROM #{table_name} WHERE id = ?;"
    MyXQL.query(pid, sql, [id])
  end
end
