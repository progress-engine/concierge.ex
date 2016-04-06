defmodule Confirmable.Mailer do
  use Mailgun.Client, Confirmable.mailer_options      

  def send_confirmation_email(resource, confirmation_url) do
    send_email to: resource.email,
               from: Confirmable.sender_address,
               subject: "Confirmation instructions",              
               html: Phoenix.View.render_to_string(Confirmable.email_view, "confirmation.html", 
                  %{resource: resource, confirmation_url: confirmation_url})
  end    
end