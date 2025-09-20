Postgrex.Types.define(
  Hyperion.PostgrexTypes,
  [] ++ Ecto.Adapters.Postgres.extensions(),
  interval_decode_type: Duration
)

