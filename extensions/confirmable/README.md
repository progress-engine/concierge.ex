# Confirmable

Module adds a confirmation logic to Concierge resource

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add confirmable to your list of dependencies in `mix.exs`:

        def deps do
          [{:confirmable, "~> 0.0.1"}]
        end

  2. Ensure confirmable is started before your application:

        def application do
          [applications: [:confirmable]]
        end

  3. Run `mix confirmable.install User users`. It will create migration to add required fields to your Concierge resource.
  4. Add fields to your resource's Schema

        field :confirmation_token, :string
        field :confirmed_at, Ecto.DateTime
        field :confirmation_sent_at, Ecto.DateTime

  5. Add Confirmable to `config/concierge.exs`

        config :concierge, Concierge,
               ....
               extensions: [Concierge.Confirmable]

  6. Add Confirmable config: `config/concierge.exs`

        config :concierge, Concierge.Confirmable,
               sender_address: "your-email@domain.com",
               mailer_options: [domain: "", key: ""] # use Mailgun configuration here

## Mailer options

Confirmable uses [Mailgun client](http://www.phoenixframework.org/docs/sending-email). You can change default mailer's options in configuration. Or you can use custom mailer with `mailer` option in config.


  


