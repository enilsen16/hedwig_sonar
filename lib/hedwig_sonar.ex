defmodule Hedwig.Adapters.Sonar do

  use Hedwig.Adapter
  require Logger

  def init({robot, opts}) do
    HTTPoison.start
    Hedwig.Robot.register(robot, opts[:name])

    state = %{
      # account_sid: opts[:account_sid],
      # account_token: opts[:auth_token],
      # account_number: opts[:account_number],
      robot: robot
    }

    { :ok, state }
  end

  def handle_cast(test, state) do
    IO.inspect "test: #{test}"
    # send_message(msg.user, msg.text, state)
    # {:noreply, state}
  end

  def handle_message(name, req_body) do
    case Hedwig.whereis(name) do
      # :undefined ->
      #   Logger.error("Robot named #{name} not found")
      #   { :error, :not_found }

        robot ->
          # msg = build_message(req_body)
          # Hedwig.Robot.handle_message(robot, msg)
          IO.inspect "req_body: #{req_body}"
          IO.inspect "robot: #{robot}"
          :ok
    end
  end
end
