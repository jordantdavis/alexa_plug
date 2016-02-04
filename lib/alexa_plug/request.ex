defmodule AlexaPlug.Request do
  @moduledoc """
  A collection of functions for interacting with incoming requests
  from the Alexa Skills Kit.

  ## Usage
  
    alias AlexaPlug.Request
  """

  @launch_request "LaunchRequest"
  @intent_request "IntentRequest"
  @session_ended_request "SessionEndedRequest"

  @doc """
  Return the request type constant `LaunchRequest`.
  """
  def launch_request, do: @launch_request

  @doc """
  Return the request type constant `IntentRequest`.
  """
  def intent_request, do: @intent_request

  @doc """
  Return the request type constant `SessionEndedRequest`.
  """
  def session_ended_request, do: @session_ended_request
end
