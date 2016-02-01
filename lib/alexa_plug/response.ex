defmodule AlexaPlug.Response do
  @moduledoc """
  A collection of functions for building responses expected by the
  Alexa Skills Kit.

  ## Usage

      alias AlexaPlug.Response

  ## Example

  To create a response:

      response = Response.new
      |> Response.add_session_attributes(%{"user" => "test"})
      |> Response.add_output_speech("PlainText", "Hello!")
      |> Response.add_card("Simple", "Title", "Content")
      |> Response.add_reprompt("PlainText", "Can I help with anything else?")
      |> Response.add_should_not_end_session

  and the following response map is created:

      %{
        "version" => "1.0",
        "sessionAttributes" => %{"user" => "test"},
        "response" => %{
          "outputSpeech" => %{
            "type" => "PlainText",
            "text" => "Can I help with anything else?"
          },
          "card": %{
            "type" => "Simple",
            "title" => "Title",
            "content" => "Content"
          },
          "reprompt" => %{
            "outputSpeech" => %{
              "type" => "PlainText",
              "text" => "Can I help with anything else?"
            }
          },
          "shouldEndSession" => false
        }
      }

  The same response can be built using convenience methods as follows:

      response = Response.new
      |> Response.add_session_attributes(%{"user" => "test"})
      |> Response.add_plain_text_output_speech("Hello!")
      |> Response.add_simple_card("Title", "Content")
      |> Response.add_plain_text_reprompt("Can I help with anything else?")
      |> Response.add_should_not_end_session

  """

  @doc """
  Create a new map with version set to `1.0` and an empty response map.
  """
  def new do
    %{"version" => "1.0", "response" => %{}}
  end

  @doc """
  Add `sessionAttributes` field to the response.
  """
  def add_session_attributes(alexa_response, session_attributes) do
    Map.put(alexa_response, "sessionAttributes", session_attributes)
  end

  @doc """
  Add `response.outputSpeech` field to the response.
  """
  def add_output_speech(%{"response" => response} = alexa_response, type, text) do
    output_speech = %{"type" => type, "text" => text}

    response = Map.put(response, "outputSpeech", output_speech)
    Map.put(alexa_response, "response", response)
  end

  @doc """
  Add `response.card` field to the response.

  This function is meant to be used with the `LinkAccount` card type.
  """
  def add_card(%{"response" => response} = alexa_response, type) do
    card = %{"type" => type}

    response = Map.put(response, "card", card)
    Map.put(alexa_response, "response", response)
  end

  @doc """
  Add `response.card` field to the response.

  This function is meant to be used with the `Simple` card type.
  """
  def add_card(%{"response" => response} = alexa_response, type, title, content) do
    card = %{"type" => type, "title" => title, "content" => content}

    response = Map.put(response, "card", card)
    Map.put(alexa_response, "response", response)
  end

  @doc """
  Add `response.reprompt` field to the response.
  """
  def add_reprompt(%{"response" => response} = alexa_response, type, text) do
    reprompt = %{"outputSpeech" => %{"type" => type, "text" => text}}

    response = Map.put(response, "reprompt", reprompt)
    Map.put(alexa_response, "response", response)
  end

  @doc """
  Add `response.shouldEndSession` field to the response set to true.
  """
  def add_should_end_session(%{"response" => response} = alexa_response) do
    response = Map.put(response, "shouldEndSession", true)
    Map.put(alexa_response, "response", response)
  end

  @doc """
  Add `response.shouldEndSession` field to the response set to false.
  """
  def add_should_not_end_session(%{"response" => response} = alexa_response) do
    response = Map.put(response, "shouldEndSession", false)
    Map.put(alexa_response, "response", response)
  end

  @doc """
  Convenience method to add `response.outputSpeech` to the response with the type set to `PlainText`.
  """
  def add_plain_text_output_speech(response, text), do: add_output_speech(response, "PlainText", text)

  @doc """
  Convenience method to add `response.outputSpeech` to the response with the type set to `SSML`.
  """
  def add_ssml_output_speech(response, text), do: add_output_speech(response, "SSML", text)

  @doc """
  Convenience method to add `response.card` to the response with the type set to `Simple`.
  """
  def add_simple_card(response, title, content), do: add_card(response, "Simple", title, content)

  @doc """
  Convenience method to add `response.card` to the response with the type set to `LinkAccount`.
  """
  def add_link_account_card(response), do: add_card(response, "LinkAccount")

  @doc """
  Convenience method to add `response.reprompt` to the response with the type set to `PlainText`.
  """
  def add_plain_text_reprompt(response, text), do: add_reprompt(response, "PlainText", text)

  @doc """
  Convenience method to add `response.reprompt` to the response with the type set to `SSML`.
  """
  def add_ssml_reprompt(response, text), do: add_reprompt(response, "SSML", text)
end
