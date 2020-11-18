defmodule Myapp.CounterMessage do
  alias Broadway.Message

  def transform(event, _opts) do
    IO.inspect(event, label: "CounterMessage.transform: event")
    IO.inspect(_opts, label: "CounterMessage.transform: opts")

    # CounterMessage.transform: event: 0
    # CounterMessage.transform: opts: []
    # CounterMessage.transform: event: 1
    # CounterMessage.transform: opts: []
    # CounterMessage.transform: event: 2
    # CounterMessage.transform: opts: []
    # CounterMessage.transform: event: 3
    # CounterMessage.transform: opts: []
    # CounterMessage.transform: event: 4
    # CounterMessage.transform: opts: []

    Process.sleep(3000)

    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, event}
    }
    |> validate_even()
  end

  def ack(_ref, _successes, _failures) do
    IO.inspect(_ref, label: "CounterMessage.ack: _ref")
    # CounterMessage.ack: _ref: :ack_id

    IO.inspect(_successes, label: "CounterMessage.ack: _successes")
    # CounterMessage.ack: _successes: [
    #   %Broadway.Message{
    #     acknowledger: {Myapp.CounterMessage, :ack_id, 0},
    #     batch_key: :default,
    #     batch_mode: :bulk,
    #     batcher: :default,
    #     data: 0,
    #     metadata: %{},
    #     status: :ok
    #   },
    #   %Broadway.Message{
    #     acknowledger: {Myapp.CounterMessage, :ack_id, 2},
    #     batch_key: :default,
    #     batch_mode: :bulk,
    #     batcher: :default,
    #     data: 2,
    #     metadata: %{},
    #     status: :ok
    #   },
    #   %Broadway.Message{
    #     acknowledger: {Myapp.CounterMessage, :ack_id, 4},
    #     batch_key: :default,
    #     batch_mode: :bulk,
    #     batcher: :default,
    #     data: 4,
    #     metadata: %{},
    #     status: :ok
    #   }
    # ]

    IO.inspect(_failures, label: "CounterMessage.ack: _failures")
    # CounterMessage.ack: _failures: [
    #   %Broadway.Message{
    #     acknowledger: {Myapp.CounterMessage, :ack_id, 1},
    #     batch_key: :default,
    #     batch_mode: :bulk,
    #     batcher: :default,
    #     data: 1,
    #     metadata: %{},
    #     status: {:failed, :odd}
    #   },
    #   %Broadway.Message{
    #     acknowledger: {Myapp.CounterMessage, :ack_id, 3},
    #     batch_key: :default,
    #     batch_mode: :bulk,
    #     batcher: :default,
    #     data: 3,
    #     metadata: %{},
    #     status: {:failed, :odd}
    #   }
    # ]

    Process.sleep(3000)

    :ok
  end

  defp validate_even(%Message{data: event} = message) when rem(event, 2) == 0 do
    message
  end

  defp validate_even(%Message{} = message) do
    Message.failed(message, :odd)
  end
end
