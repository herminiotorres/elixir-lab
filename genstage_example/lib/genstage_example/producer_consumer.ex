defmodule GenstageExample.ProducerConsumer do
  use GenStage

  require Integer

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [GenstageExample.Producer]}
  end

  # iex[1]> require Integer
  # Integer
  # iex[2]> [1,2,3,4,5,6] |> Enum.filter(&Integer.is_even/1)
  # [2, 4, 6]
  def handle_events(events, _from, state) do
    only_even_numbers =
      events
      |> Enum.filter(&Integer.is_even/1)

    {:noreply, only_even_numbers, state}
  end
end
