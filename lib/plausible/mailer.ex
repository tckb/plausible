defmodule Plausible.Mailer do
  use Bamboo.Mailer, otp_app: :plausible

  def send_email(email) do
    try do
      Plausible.Mailer.deliver_now(email)
    rescue
      error  ->
        Sentry.capture_exception(error, [stacktrace: __STACKTRACE__, extra: %{extra: "Error while sending email"}])
        raise error
    end
  end

end
