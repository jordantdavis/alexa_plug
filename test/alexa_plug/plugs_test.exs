defmodule AlexaPlug.PlugsTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import AlexaPlug.Plugs

  doctest AlexaPlug

  # Launch request tests

  test "it extracts a value from a Launch request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", launch_request)
    conn = conn
    |> fetch_echo_session_attributes
    |> fetch_echo_user_id
    |> fetch_echo_request_type
    |> fetch_echo_intent_type
    |> fetch_echo_slots

    ask_request = conn.assigns[:ask_request]

    assert ask_request[:session_attributes] == %{}
    assert ask_request[:user_id] == "amzn1.account.AM3B00000000000000000000000"
    assert ask_request[:request_type] == "LaunchRequest"
    assert ask_request[:intent_type] == nil
    assert ask_request[:slots] == nil
  end

  test "it extracts all values from a Launch request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", launch_request)
    conn = conn
    |> fetch_echo_request_data

    ask_request = conn.assigns[:ask_request]

    assert ask_request[:session_attributes] == %{}
    assert ask_request[:user_id] == "amzn1.account.AM3B00000000000000000000000"
    assert ask_request[:request_type] == "LaunchRequest"
    assert ask_request[:intent_type] == nil
    assert ask_request[:slots] == nil
  end

  # Intent request tests

  test "it extracts a value from an Intent request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", intent_request)
    conn = conn
    |> fetch_echo_session_attributes
    |> fetch_echo_user_id
    |> fetch_echo_request_type
    |> fetch_echo_intent_type
    |> fetch_echo_slots

    session_attributes = %{
      "supportedHoroscopePeriods" => %{
        "daily" => true,
        "weekly" => false,
        "monthly" => false
      }
    }

    ask_request = conn.assigns[:ask_request]

    assert ask_request[:session_attributes] == session_attributes
    assert ask_request[:user_id] == "amzn1.account.AM3B00000000000000000000000"
    assert ask_request[:request_type] == "IntentRequest"
    assert ask_request[:intent_type] == "GetZodiacHoroscopeIntent"
    assert ask_request[:slots] == %{"ZodiacSign" => "virgo"}
  end

  test "it extracts all values from an Intent request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", intent_request)
    conn = conn
    |> fetch_echo_request_data

    session_attributes = %{
      "supportedHoroscopePeriods" => %{
        "daily" => true,
        "weekly" => false,
        "monthly" => false
      }
    }

    ask_request = conn.assigns[:ask_request]

    assert ask_request[:session_attributes] == session_attributes
    assert ask_request[:user_id] == "amzn1.account.AM3B00000000000000000000000"
    assert ask_request[:request_type] == "IntentRequest"
    assert ask_request[:intent_type] == "GetZodiacHoroscopeIntent"
    assert ask_request[:slots] == %{"ZodiacSign" => "virgo"}
  end

  # SessionEnded request tests

  test "it extracts a value from a SessionEnded request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", session_ended_request)
    conn = conn
    |> fetch_echo_session_attributes
    |> fetch_echo_user_id
    |> fetch_echo_request_type
    |> fetch_echo_intent_type
    |> fetch_echo_slots

    session_attributes = %{
      "supportedHoroscopePeriods" => %{
        "daily" => true,
        "weekly" => false,
        "monthly" => false
      }
    }

    ask_request = conn.assigns[:ask_request]

    assert ask_request[:session_attributes] == session_attributes
    assert ask_request[:user_id] == "amzn1.account.AM3B00000000000000000000000"
    assert ask_request[:request_type] == "SessionEndedRequest"
    assert ask_request[:intent_type] == nil
    assert ask_request[:slots] == nil
  end

  test "it extracts all values from a SessionEnded request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", session_ended_request)
    conn = conn
    |> fetch_echo_request_data

    session_attributes = %{
      "supportedHoroscopePeriods" => %{
        "daily" => true,
        "weekly" => false,
        "monthly" => false
      }
    }

    ask_request = conn.assigns[:ask_request]

    assert ask_request[:session_attributes] == session_attributes
    assert ask_request[:user_id] == "amzn1.account.AM3B00000000000000000000000"
    assert ask_request[:request_type] == "SessionEndedRequest"
    assert ask_request[:intent_type] == nil
    assert ask_request[:slots] == nil
  end

  # example requests for each type

  defp launch_request do
    %{
      "version" => "1.0",
      "session" => %{
        "new" => true,
        "sessionId" => "amzn1.echo-api.session.0000000-0000-0000-0000-00000000000",
        "application" => %{
          "applicationId" => "amzn1.echo-sdk-ams.app.000000-d0ed-0000-ad00-000000d00ebe"
        },
        "attributes" => %{},
        "user" => %{
          "userId" => "amzn1.account.AM3B00000000000000000000000"
        }
      },
      "request" => %{
        "type" => "LaunchRequest",
        "requestId" => "amzn1.echo-api.request.0000000-0000-0000-0000-00000000000",
        "timestamp" => "2015-05-13T12:34:56Z"
      }
    }
  end

  defp intent_request do
    %{
      "version" => "1.0",
      "session" => %{
        "new" => false,
        "sessionId" => "amzn1.echo-api.session.0000000-0000-0000-0000-00000000000",
        "application" => %{
          "applicationId" => "amzn1.echo-sdk-ams.app.000000-d0ed-0000-ad00-000000d00ebe"
        },
        "attributes" => %{
          "supportedHoroscopePeriods" => %{
            "daily" => true,
            "weekly" => false,
            "monthly" => false
          }
        },
        "user" => %{
          "userId" => "amzn1.account.AM3B00000000000000000000000"
        }
      },
      "request" => %{
        "type" => "IntentRequest",
        "requestId" => " amzn1.echo-api.request.0000000-0000-0000-0000-00000000000",
        "timestamp" => "2015-05-13T12:34:56Z",
        "intent" => %{
          "name" => "GetZodiacHoroscopeIntent",
          "slots" => %{
            "ZodiacSign" => %{
              "name" => "ZodiacSign",
              "value" => "virgo"
            }
          }
        }
      }
    }
  end

  defp session_ended_request do
    %{
      "version" => "1.0",
      "session" => %{
        "new" => false,
        "sessionId" => "amzn1.echo-api.session.0000000-0000-0000-0000-00000000000",
        "application" => %{
          "applicationId" => "amzn1.echo-sdk-ams.app.000000-d0ed-0000-ad00-000000d00ebe"
        },
        "attributes" => %{
          "supportedHoroscopePeriods" => %{
            "daily" => true,
            "weekly" => false,
            "monthly" => false
          }
        },
        "user" => %{
          "userId" => "amzn1.account.AM3B00000000000000000000000"
        }
      },
      "request" => %{
        "type" => "SessionEndedRequest",
        "requestId" => "amzn1.echo-api.request.0000000-0000-0000-0000-00000000000",
        "timestamp" => "2015-05-13T12:34:56Z",
        "reason" => "USER_INITIATED"
      }
    }
  end
end
