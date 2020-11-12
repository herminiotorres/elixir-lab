defmodule GenstageExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias GenstageExample.{Consumer, Producer, ProducerConsumer}

  @impl true
  def start(_type, _args) do
    children =
      [
        {Producer, 0},
        {ProducerConsumer, []}
      ] ++ create_consumer_childrens()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: GenstageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # use all cores to consume
  defp create_consumer_childrens do
    schedulers = number_of_cores() * number_of_threads_per_core()

    1..schedulers |> Enum.map(&{Consumer, &1})
  end

  defp number_of_cores, do: System.schedulers()
  defp number_of_threads_per_core, do: 2
end
