module Mailgun
  class Event

    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    def find(params)
      Mailgun.submit :get, events_url, params
    end

    private
    def events_url
      "#{@mailgun.base_url}#{@domain}/events"
    end

  end
end
