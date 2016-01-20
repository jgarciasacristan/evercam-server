defmodule EvercamMedia do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ConCache, [[ttl_check: 100, ttl: 1300], [name: :cache]]),
      worker(ConCache, [[ttl_check: 100, ttl: 1500], [name: :snapshot_schedule]], id: :snapshot_schedule),
      worker(ConCache, [[ttl_check: 100, ttl: :timer.seconds(60)], [name: :camera_lock]], id: :camera_lock),
      worker(ConCache, [[ttl_check: :timer.seconds(1), ttl: :timer.seconds(5*60)], [name: :camera]], id: :camera),
      worker(ConCache, [[ttl_check: :timer.seconds(60*60), ttl: :timer.seconds(3*24*60*60)], [name: :snapshot_error]], id: :snapshot_error),
      supervisor(EvercamMedia.Endpoint, []),
      supervisor(EvercamMedia.Repo, []),
      supervisor(EvercamMedia.SnapshotRepo, []),
      supervisor(EvercamMedia.Snapshot.StreamerSupervisor, []),
      supervisor(EvercamMedia.Snapshot.WorkerSupervisor, []),
      :hackney_pool.child_spec(:snapshot_pool,  [timeout: 5000, max_connections: 1000])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EvercamMedia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EvercamMedia.Endpoint.config_change(changed, removed)
    :ok
  end
end
