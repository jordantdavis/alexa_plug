defmodule AlexaPlug.Plugs do
  @moduledoc """
  A collection of plugs for extracting data from Amazon Echo requests.

  The plugs fetch specific data from Amazon Echo requests and places
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
      plug :fetch_echo_request_type
      plug :fetch_echo_intent_type
      plug :fetch_echo_slots

      # or use all plugs with

      plug :fetch_echo_request_data

  then `conn.assigns` will contain:

      %{
        session_attributes: %{
          "supportedHoroscopePeriods" => %{
            "daily" => true,
            "weekly" => false,
            "monthly" => false
          }
        },
        request_type: "IntentRequest",
        intent_type: "GetZodiacHoroscopeIntent",
        slots: %{"ZodiacSign" => "virgo"}
      }

  To see more info on all request types see the
  [ASK Interface Reference](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/alexa-skills-kit-interface-reference)
  for details.
  """

  import Plug.Conn

  @doc """
  Fetch the session attributes from an Amazon Echo request.

  Assigns `conn.assigns` the value for the request field `session.attributes` or nil.
  """
  def fetch_echo_session_attributes(conn, _opts \\ nil) do
    session_attributes = get_in(conn.params, ["session", "attributes"])
    assign(conn, :session_attributes, session_attributes)
  end

  @doc """
  Fetch the request type from an Amazon Echo request.

  Assigns `conn.assigns` the value for the request field `request.type` or nil.
  """
  def fetch_echo_request_type(conn, _opts \\ nil) do
    request_type = get_in(conn.params, ["request", "type"])
    assign(conn, :request_type, request_type)
  end

  @doc """
  Fetch the intent type from an Amazon Echo request.

  Assigns `conn.assigns` the value for the request field `request.intent.name` or nil.
  """
  def fetch_echo_intent_type(conn, _opts \\ nil) do
    intent_type = get_in(conn.params, ["request", "intent", "name"])
    assign(conn, :intent_type, intent_type)
  end

  @doc """
  Fetch the slots from an Amazon Echo request.

  For the given slots:

      "slots": {
        "(key)": {
          "name": "ZodiacSign",
          "value": "virgo"
        }
      }

  A slots map is created using the **slot key** (not the slot name) and the **slot value** as key-value pairs.

  Assigns `conn.assigns` the value for the request field `request.intent.slots` or nil.
  """
  def fetch_echo_slots(conn, _opts \\ nil) do
    slots = get_in(conn.params, ["request", "intent", "slots"])

    if slots do
      mapped_slots = Enum.reduce(slots, %{}, fn ({slot_name, slot_object}, acc) ->
        Map.put(acc, slot_name, slot_object["value"])
      end)

      assign(conn, :slots, mapped_slots)
    else
      assign(conn, :slots, nil)
    end
  end

  @doc """
  Fetch the session attributes, request type, intent type, and slots
  from an Amazon Echo request.

  Calls all the other plugs on defined in this module.
  """
  def fetch_echo_request_data(conn, _opts \\ nil) do
    conn
    |> fetch_echo_session_attributes
    |> fetch_echo_request_type
    |> fetch_echo_intent_type
    |> fetch_echo_slots
  end
end
