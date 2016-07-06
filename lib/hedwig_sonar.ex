defmodule Hedwig.Adapters.Sonar do

  use Hedwig.Adapter
  require Logger

  def init({robot, opts}) do
    HTTPoison.start
    Hedwig.Robot.register(robot, opts[:name])

    state = %{
      robot: robot
    }

    { :ok, state }
  end

  def handle_cast({:send, msg}, state) do
    send_message(msg.user[:phone_number], msg.text)
    {:noreply, state}
  end

  def handle_message(name, req_body) do
    case Hedwig.whereis(name) do
      :undefined ->
        Logger.error("Robot named #{name} not found")
        { :error, :not_found }

      robot ->
        msg = build_message(req_body)
        Hedwig.Robot.handle_message(robot, msg)
        :ok
    end
  end

  defp build_message(body) when is_binary(body) do
    build_message Poison.Parser.parse!(body)
  end

  defp build_message(body) do
    %Hedwig.Message{
      ref: make_ref(),
      # action: body["action"],
      text: body["text"],
      type: "SMSMessage",
      # customer: %{
      #   email: body["customer"]["email"],
      #   fb_id: body["customer"]["fb_id"],
      #   first_name: body["customer"]["first_name"],
      #   phone_number: body["customer"]["phone_number"]
      # },
      user: %{
          email: body["customer"]["email"],
          fb_id: body["customer"]["fb_id"],
          first_name: body["customer"]["first_name"],
          first_name: body["customer"]["last_name"],
          phone_number: body["customer"]["phone_number"]
        # first_name: body["user"]["first_name"],
        # last_name: body["user"]["last_name"],
        # email: body["user"]["email"]
      }
      # media_url: body["media_url"],
      # sonar_link: body["link"]
    }
  end

  defp send_message(phone_number, body) do
    ExSonar.Messages.send(phone_number, body)
  end
end
