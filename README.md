# Concierge

Authentication solution for Phoenix and Elixir using Guardian.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add concierge to your list of dependencies in `mix.exs`:

        def deps do
          [{:concierge, "~> 0.0.1"}]
        end

  2. Ensure concierge is started before your application:

        def application do
          [applications: [:concierge]]
        end

  3. Run `mix concierge.install`
  4. Add to `config/config.exs` 

        import_config "concierge.exs"

  5. Add to `web/web.ex`

        def controller do 
          quote do 
            # ...
            use Concierge.Controller
            plug Concierge.Plug.Authentication
          end  
        end

        def view do
          quote do
            # ...
            use Concierge.Helpers
          end
        end

  6. Add to `web/router.ex`

        concierge at: "users", pipe_through: [:browser]

  7. Start server and open [http://localhost:4000/users/sign_in](http://localhost:4000/users/sign_in)
         
## Usage

### Helpers

You will have `current_user(@conn)` and `user_signed_in?(@conn)` helpers in views.

### Protecting endpoints

Concierge provides `ensure_authenticated!` controller filter. It accepts `:only` and `:except` options.

    defmodule Example.PageController do
      use Example.Web, :controller

      ensure_authenticated! only: [:protected]

      def index(conn, _params) do
        render conn, "index.html"
      end

      def protected(conn, _params) do
        render conn, "protected.html"
      end
    end

## TODO

- I18n
- Confirmations
- OAuth

