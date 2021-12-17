import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :job_finder, JobFinderWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "r7maFLrif7zl0yph4cmuTu7sdSEkHMk3YNN+CkLMpD6k7HL1LgRBreNtolSFgEgP",
  server: false

config :job_finder,
       jobs_file: "technical-test-jobs.csv"

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
