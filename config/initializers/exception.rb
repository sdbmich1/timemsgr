Timemsgr::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "Koncierge-Errors: ",
  :sender_address => %{"Koncierge Admin" <koncierge@rbca.net>},
  :exception_recipients => %w{sdbmich1@gmail.com}