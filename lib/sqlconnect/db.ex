defmodule SQLconnect.DB do
  @moduledoc """
  CRUD обёртка для таблицы `users` с автоматическим созданием таблицы при первом запуске.
  """

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

  def init_table do
    pid = connect()
    sql = """
    CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(50),
      email VARCHAR(50)
    );
    """
    MyXQL.query(pid, sql)
  end

  def create_user(name, email) do
    pid = connect()
    sql = "INSERT INTO users (name, email) VALUES (?, ?);"
    MyXQL.query(pid, sql, [name, email])
  end

  def list_users do
    pid = connect()
    sql = "SELECT * FROM users;"
    {:ok, result} = MyXQL.query(pid, sql)
    result.rows
  end

  def get_user(id) do
    pid = connect()
    sql = "SELECT * FROM users WHERE id = ?;"
    {:ok, result} = MyXQL.query(pid, sql, [id])
    case result.rows do
      [] -> nil
      [user] -> user
    end
  end

  def update_user(id, name, email) do
    pid = connect()
    sql = "UPDATE users SET name = ?, email = ? WHERE id = ?;"
    MyXQL.query(pid, sql, [name, email, id])
  end

  def delete_user(id) do
    pid = connect()
    sql = "DELETE FROM users WHERE id = ?;"
    MyXQL.query(pid, sql, [id])
  end
end
