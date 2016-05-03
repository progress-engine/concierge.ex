defmodule Concierge.Resource.Registration do
  @moduledoc """
  Holds registration-related functions
  """

  defmodule Callbacks do
    @moduledoc """
    Defines callbacks for resource registration actions
    """

    @callback before_create(Ecto.Changeset.t) :: any
    @callback after_create(Ecto.Schema.t) :: any
  end

  @doc """
  Creates resource from given parameters. 
  By default resource requires `email`, `password` and `password_confirmation` parameters.

  Returns `{:ok, resource}` if creation was successful; otherwise returns `{:error, changeset}`.
  `resource` is a `Ecto.Schema` module represeting your resource.
  `changeset` is a `Ecto.Changeset` module.

  ## Examples

    def create(conn, params) do
      result = 
        params 
          |> Map.take(["email", "password", "password_confirmation"])
          |> Concierge.Resource.create

      case result do
        {:ok, resource} ->
          conn 
            |> put_flash("Successfully registered")
            |> redirect(to: "/")
        {:error, changeset} ->
          conn
            |> render("new.html", changeset: changeset)    
      end    
    end  
  """
  def create(params) do
    changeset = Concierge.resource.changeset(Concierge.resource.__struct__, params)
    
    {:ok, result} = 
      Concierge.repo.transaction(fn ->    
        Concierge.Utils.invoke_on_extensions(:before_create, [changeset])

        res = 
          changeset 
          |> Concierge.Resource.put_encrypted_password
          |> Concierge.repo.insert

        case res do
          {:ok, resource} -> Concierge.Utils.invoke_on_extensions(:after_create, [resource])
          {:error, _} -> nil
        end    
        res
      end)

    result
  end
end