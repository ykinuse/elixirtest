defmodule Issues.GithubIssues do
  @user_agent  [ {"User-agent", "Elixir dave@pragprog.com"} ]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
   issues_url(user, project)
   |> HTTPoison.get(@user_agent)
   |> handle_response
  end

  def issues_url(user, project) do
   "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
   { :ok,    Poison.Parser.parse!(body) }
  end

  def handle_response({ ___, %{status_code: ___, body: body}}) do
   { :error, Poison.Parser.parse!(body) }
  end

  def handle_response({_, %HTTPoison.Response{:body => body}}) do
    {_, message} = Poison.Parser.parse(body)
    {:error, message["message"]}
  end

  def handle_response({ ___, body}) do
   { :error, body}
  end
end
