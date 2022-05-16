import Config

config :todo, :database, pool_size: 3, folder: "./persist"

import_config "#{Mix.env()}.exs"
