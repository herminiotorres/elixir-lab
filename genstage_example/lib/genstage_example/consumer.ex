defmodule GenstageExample.Consumer do
  use GenStage

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [GenstageExample.ProducerConsumer]}
  end

  # $ mix run --no-halt
  # Consumer: {#PID<0.191.0>, 6500, :state_doesnt_matter}
  # Consumer: {#PID<0.190.0>, 6000, :state_doesnt_matter}
  # Consumer: {#PID<0.182.0>, 1500, :state_doesnt_matter}
  # Consumer: {#PID<0.184.0>, 3000, :state_doesnt_matter}
  # Consumer: {#PID<0.183.0>, 2500, :state_doesnt_matter}
  # Consumer: {#PID<0.198.0>, 10000, :state_doesnt_matter}
  # Consumer: {#PID<0.204.0>, 13000, :state_doesnt_matter}
  # Consumer: {#PID<0.185.0>, 3500, :state_doesnt_matter}
  # Consumer: {#PID<0.199.0>, 10500, :state_doesnt_matter}
  # Consumer: {#PID<0.187.0>, 4500, :state_doesnt_matter}
  # Consumer: {#PID<0.192.0>, 7000, :state_doesnt_matter}
  # Consumer: {#PID<0.188.0>, 5000, :state_doesnt_matter}
  # Consumer: {#PID<0.196.0>, 9000, :state_doesnt_matter}
  # Consumer: {#PID<0.200.0>, 11000, :state_doesnt_matter}
  # Consumer: {#PID<0.203.0>, 12500, :state_doesnt_matter}
  # Consumer: {#PID<0.181.0>, 0, :state_doesnt_matter}
  # ...
  def handle_events(only_even_numbers, _from, state) do
    for number <- only_even_numbers do
      IO.inspect({self(), number, state}, label: "Consumer")
    end

    # As a consumer we never emit events
    {:noreply, [], state}
  end

  def child_spec(id) do
    %{
      id: id,
      start: {__MODULE__, :start_link, [[]]},
      restart: :permanent,
      type: :worker
    }
  end
end
