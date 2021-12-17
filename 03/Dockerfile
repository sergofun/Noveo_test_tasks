FROM elixir:1.12.2-alpine


RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mix local.rebar --force && \
    mix local.hex --force && \
    mix deps.get

CMD ["iex", "-S", "mix", "phx.server"]
