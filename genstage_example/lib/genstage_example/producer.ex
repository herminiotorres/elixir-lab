defmodule GenstageExample.Producer do
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter) do
    {:producer, counter}
  end

  # iex[1]> state = 0
  # 0
  # iex[2]> demand = 3
  # 3
  # iex[3]> Enum.to_list(state..(state + demand-1))
  # [0, 1, 2]
  def handle_demand(demand, state) do
    infinity_list = Enum.to_list(state..(state + demand - 1))
    {:noreply, infinity_list, state + demand}
  end
end
