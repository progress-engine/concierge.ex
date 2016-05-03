defmodule Recoverable.Mailer do
  use Concierge.Mailer

  def send_reset_password_notification(resource, reset_password_url) do
    # IO.inspect Phoenix.View.render(Recoverable.EmailView, "reset_password_notification.html", )

    send_email to: resource.email,
               from: Concierge.sender_address, 
               subject: "Reset password instructions",              
               html: Phoenix.View.render_to_string(Recoverable.email_view, "reset_password_notification.html", 
                  resource: resource, reset_password_url: reset_password_url)
  end      
end
