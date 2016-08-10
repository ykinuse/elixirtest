defmodule Issues.GithubIssues do
  require(Logger)
  @user_agent  [ {"User-agent", "Elixir dave@pragprog.com"} ]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.debug("Fetch user #{user}'s project #{project}")
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    Logger.debug("Fetch status success")
    { :ok,    Poison.Parser.parse!(body) }
  end

  def handle_response({ _,   %{status_code:   _, body: body}}) do
    Logger.debug("Fetch status failed")
    { :error, Poison.Parser.parse!(body) }
  end

  def handle_response({ _, %HTTPoison.Response{:body => body}}) do
    Logger.debug("Fetch status failed")
    {_, message} = Poison.Parser.parse(body)
    {:error, message["message"]}
  end

  def handle_response({ _, body}) do
    Logger.debug("Fetch status failed")
    { :error, body}
  end
end
