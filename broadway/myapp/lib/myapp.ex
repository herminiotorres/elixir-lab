defmodule Myapp do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {Myapp.Counter, 0},
        transformer: {Myapp.CounterMessage, :transform, []},
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 1]
      ]
    )
  end

  def handle_message(:default, %Message{data: data} = message, _context) do
    Process.sleep(3000)

    IO.inspect(_context, label: "Broadway - Message = context:")
    # Broadway - Message = context: :context_not_set

    # Broadway - Message = handle_message: %Broadway.Message{
    #   acknowledger: {Myapp.CounterMessage, :ack_id, 0},
    #   batch_key: :default,
    #   batch_mode: :bulk,
    #   batcher: :default,
    #   data: 0,
    #   metadata: %{},
    #   status: :ok
    # }
    # Broadway - Message = handle_message: %Broadway.Message{
    #   acknowledger: {Myapp.CounterMessage, :ack_id, 1},
    #   batch_key: :default,
    #   batch_mode: :bulk,
    #   batcher: :default,
    #   data: 1,
    #   metadata: %{},
    #   status: {:failed, :odd}
    # }
    # Broadway - Message = handle_message: %Broadway.Message{
    #   acknowledger: {Myapp.CounterMessage, :ack_id, 2},
    #   batch_key: :default,
    #   batch_mode: :bulk,
    #   batcher: :default,
    #   data: 2,
    #   metadata: %{},
    #   status: :ok
    # }
    # Broadway - Message = handle_message: %Broadway.Message{
    #   acknowledger: {Myapp.CounterMessage, :ack_id, 3},
    #   batch_key: :default,
    #   batch_mode: :bulk,
    #   batcher: :default,
    #   data: 3,
    #   metadata: %{},
    #   status: {:failed, :odd}
    # }
    # Broadway - Message = handle_message: %Broadway.Message{
    #   acknowledger: {Myapp.CounterMessage, :ack_id, 4},
    #   batch_key: :default,
    #   batch_mode: :bulk,
    #   batcher: :default,
    #   data: 4,
    #   metadata: %{},
    #   status: :ok
    # }

    IO.inspect(message, label: "Broadway - Message = handle_message:")
  end
end
