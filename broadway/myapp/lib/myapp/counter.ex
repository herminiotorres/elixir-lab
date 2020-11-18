defmodule Myapp.Counter do
  use GenStage

  def start_link(counter) do
    GenStage.start_link(__MODULE__, counter)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    IO.inspect(demand, label: "Myapp.Counter .handle_demand - demand")
    IO.inspect(counter, label: "Myapp.Counter .handle_demand - counter")

    events = Enum.to_list(counter..(counter + demand - 1))
    IO.inspect(events, label: "Myapp.Counter .handle_demand - events")

    # Myapp.Counter .handle_demand - demand: 10
    # Myapp.Counter .handle_demand - counter: 0
    # Myapp.Counter .handle_demand - events: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

    Process.sleep(3000)

    {:noreply, events, counter + demand}
  end
end
