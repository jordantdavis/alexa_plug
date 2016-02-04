defmodule AlexaPlug.Plugs do
  @moduledoc """
  A collection of plugs for extracting data from Alexa Skills Kit requests.

  The plugs fetch specific data from Alexa Skills Kit requests and places
  that data in `conn.assigns`.

  ## Usage

      import AlexaPlug.Plugs

  ## Example

  When the following request is received (fields omitted for brevity):
      {
        ...
        "session": {
          ...
          "attributes": {
            "supportedHoroscopePeriods": {
              "daily": true,
              "weekly": false,
              "monthly": false
            }
          },
          "user": {
            "userId": "amzn1.account.AM3B00000000000000000000000"
          },
          ...
        },
        "request": {
          "type": "IntentRequest",
          ...
          "intent": {
            "name": "GetZodiacHoroscopeIntent",
            "slots": {
              "ZodiacSign": {
                "name": "ZodiacSign",
                "value": "virgo"
              }
            }
          }
        }
      }

  and the following plugs are being used:

      plug :fetch_echo_session_attributes
      plug :fetch_echo_user_id
      plug :fetch_echo_request_type
      plug :fetch_echo_intent_type
      plug :fetch_echo_slots

      # or use all plugs with

      plug :fetch_echo_request_data

  then `conn.assigns` will contain:

      %{
        ask_request: %{
          session_attributes: %{
            "supportedHoroscopePeriods" => %{
              "daily" => true,
              "weekly" => false,
              "monthly" => false
            }
          },
          user_id: "amzn1.account.AM3B00000000000000000000000",
          request_type: "IntentRequest",
          intent_type: "GetZodiacHoroscopeIntent",
          slots: %{"ZodiacSign" => "virgo"}
        }
      }

  To see more info on all request types see the
  [ASK Interface Reference](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference)
  for details.
  """

  import Plug.Conn

  @doc """
  Fetch the session attributes from an Alexa Skills Kit request.

  Assigns `conn.assigns[:ask_request][:session_attributes]` the value
  for the request field `session.attributes` or nil.
  """
  def fetch_echo_session_attributes(conn, _opts \\ nil) do
    session_attributes = get_in(conn.params, ["session", "attributes"])
    assign_to_ask_request(conn, :session_attributes, session_attributes)
  end

  @docs """
  Fetch the user ID from an Alexa Skills Kit request.

  Assigns `conn.assigns[:ask_request][:user_id]` the value for the
  request field `session.user.userId` or nil.
  """
  def fetch_echo_user_id(conn, _opts \\ nil) do
    user_id = get_in(conn.params, ["session", "user", "userId"])
    assign_to_ask_request(conn, :user_id, user_id)
  end

  @doc """
  Fetch the request type from an Alexa Skills Kit request.

  Assigns `conn.assigns[:ask_request][:request_type]` the value for
  the request field `request.type` or nil.
  """
  def fetch_echo_request_type(conn, _opts \\ nil) do
    request_type = get_in(conn.params, ["request", "type"])
    assign_to_ask_request(conn, :request_type, request_type)
  end

  @doc """
  Fetch the intent type from an Alexa Skills Kit request.

  Assigns `conn.assigns[:ask_request][:intent_type]` the value for
  the request field `request.intent.name` or nil.
  """
  def fetch_echo_intent_type(conn, _opts \\ nil) do
    intent_type = get_in(conn.params, ["request", "intent", "name"])
    assign_to_ask_request(conn, :intent_type, intent_type)
  end

  @doc """
  Fetch the slots from an Alexa Skills Kit request.

  For the given slots:

      "slots": {
        "(key)": {
          "name": "ZodiacSign",
          "value": "virgo"
        }
      }

  A slots map is created using the **slot key** (not the slot name)
  and the **slot value** as key-value pairs.

  Assigns `conn.assigns[:ask_request][:slots]` the value for the
  request field `request.intent.slots` or nil.
  """
  def fetch_echo_slots(conn, _opts \\ nil) do
    slots = get_in(conn.params, ["request", "intent", "slots"])

    if slots do
      mapped_slots = Enum.reduce(slots, %{}, fn ({slot_name, slot_object}, acc) ->
        Map.put(acc, slot_name, slot_object["value"])
      end)

      assign_to_ask_request(conn, :slots, mapped_slots)
    else
      assign_to_ask_request(conn, :slots, nil)
    end
  end

  @doc """
  Fetch the session attributes, request type, intent type, and slots
  from an Alexa Skills Kit request.

  Calls all the other plugs on defined in this module.
  """
  def fetch_echo_request_data(conn, _opts \\ nil) do
    conn
    |> fetch_echo_session_attributes
    |> fetch_echo_user_id
    |> fetch_echo_request_type
    |> fetch_echo_intent_type
    |> fetch_echo_slots
  end

  # helper function for assigning fetched request attributes
  # to the nested :ask_request map
  defp assign_to_ask_request(conn, key, value) do
    ask_request_map = Map.get(conn.assigns, :ask_request)

    if ask_request_map do
      assign(conn, :ask_request, Map.put(ask_request_map, key, value))
    else
      assign(conn, :ask_request, Map.put(%{}, key, value))
    end
  end
end
