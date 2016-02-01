defmodule AlexaResponseTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias AlexaPlug.Response

  test "creates new, empty response" do
    response = Response.new

    expected_response = %{
      "version" => "1.0",
      "response" => %{}
    }

    assert response == expected_response
  end

  test "creates new response with session attributes" do
    response = Response.new
    |> Response.add_session_attributes(%{"user" => "test"})

    expected_response = %{
      "version" => "1.0",
      "sessionAttributes" => %{
        "user" => "test"
      },
      "response" => %{}
    }

    assert response == expected_response
  end

  test "creates new response with output speech" do
    response = Response.new
    |> Response.add_output_speech("PlainText", "Hello!")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "outputSpeech" => %{
          "type" => "PlainText",
          "text" => "Hello!"
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with card with only a type" do
    response = Response.new
    |> Response.add_card("LinkAccount")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "card" => %{
          "type" => "LinkAccount"
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with card" do
    response = Response.new
    |> Response.add_card("Simple", "Title", "Content")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "card" => %{
          "type" => "Simple",
          "title" => "Title",
          "content" => "Content"
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with reprompt" do
    response = Response.new
    |> Response.add_reprompt("PlainText", "Can I help with anything else?")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "reprompt" => %{
          "outputSpeech" => %{
            "type" => "PlainText",
            "text" => "Can I help with anything else?"
          }
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with shouldEndSession set to true" do
    response = Response.new
    |> Response.add_should_end_session

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "shouldEndSession" => true
      }
    }

    assert response == expected_response
  end

  test "creates new response with shouldEndSession set to false" do
    response = Response.new
    |> Response.add_should_not_end_session

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "shouldEndSession" => false
      }
    }

    assert response == expected_response
  end

  test "creates new response with PlainText output speech" do
    response = Response.new
    |> Response.add_plain_text_output_speech("Hello!")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "outputSpeech" => %{
          "type" => "PlainText",
          "text" => "Hello!"
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with SSML output speech" do
    response = Response.new
    |> Response.add_ssml_output_speech("<speak>Hello!</speak>")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "outputSpeech" => %{
          "type" => "SSML",
          "text" => "<speak>Hello!</speak>"
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with Simple card" do
    response = Response.new
    |> Response.add_simple_card("Title", "Content")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "card" => %{
        "type" => "Simple",
        "title" => "Title",
        "content" => "Content"
      }
      }
    }

    assert response == expected_response
  end

  test "creates new response with LinkAccount card" do
    response = Response.new
    |> Response.add_link_account_card

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "card" => %{
          "type" => "LinkAccount"
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with PlainText reprompt" do
    response = Response.new
    |> Response.add_plain_text_reprompt("Can I help with anything else?")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "reprompt" => %{
          "outputSpeech" => %{
            "type" => "PlainText",
            "text" => "Can I help with anything else?"
          }
        }
      }
    }

    assert response == expected_response
  end

  test "creates new response with SSML reprompt" do
    response = Response.new
    |> Response.add_ssml_reprompt("<speak>Can I help with anything else?</speak>")

    expected_response = %{
      "version" => "1.0",
      "response" => %{
        "reprompt" => %{
          "outputSpeech" => %{
            "type" => "SSML",
            "text" => "<speak>Can I help with anything else?</speak>"
          }
        }
      }
    }

    assert response == expected_response
  end
end
