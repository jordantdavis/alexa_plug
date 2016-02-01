defmodule AlexaPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import AlexaPlug.Plugs

  doctest AlexaPlug

  # Launch request tests

  test "it extracts a value from a Launch request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", launch_request)
    conn = conn
    |> fetch_echo_session_attributes
    |> fetch_echo_request_type
    |> fetch_echo_intent_type
    |> fetch_echo_slots

    assert conn.assigns[:session_attributes] == %{}
    assert conn.assigns[:request_type] == "LaunchRequest"
    assert conn.assigns[:intent_type] == nil
    assert conn.assigns[:slots] == nil
  end

  test "it extracts all values from a Launch request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", launch_request)
    conn = conn
    |> fetch_echo_request_data

    assert conn.assigns[:session_attributes] == %{}
    assert conn.assigns[:request_type] == "LaunchRequest"
    assert conn.assigns[:intent_type] == nil
    assert conn.assigns[:slots] == nil
  end

  # Intent request tests

  test "it extracts a value from an Intent request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", intent_request)
    conn = conn
    |> fetch_echo_session_attributes
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

    assert conn.assigns[:session_attributes] == session_attributes
    assert conn.assigns[:request_type] == "IntentRequest"
    assert conn.assigns[:intent_type] == "GetZodiacHoroscopeIntent"
    assert conn.assigns[:slots] == %{"ZodiacSign" => "virgo"}
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

    assert conn.assigns[:session_attributes] == session_attributes
    assert conn.assigns[:request_type] == "IntentRequest"
    assert conn.assigns[:intent_type] == "GetZodiacHoroscopeIntent"
    assert conn.assigns[:slots] == %{"ZodiacSign" => "virgo"}
  end

  # SessionEnded request tests

  test "it extracts a value from a SessionEnded request successfully" do
    conn = conn(:post, "/api/callbacks/alexa", session_ended_request)
    conn = conn
    |> fetch_echo_session_attributes
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

    assert conn.assigns[:session_attributes] == session_attributes
    assert conn.assigns[:request_type] == "SessionEndedRequest"
    assert conn.assigns[:intent_type] == nil
    assert conn.assigns[:slots] == nil
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

    assert conn.assigns[:session_attributes] == session_attributes
    assert conn.assigns[:request_type] == "SessionEndedRequest"
    assert conn.assigns[:intent_type] == nil
    assert conn.assigns[:slots] == nil
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
