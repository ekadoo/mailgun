module Mailgun
  class Event

    attr_reader :next_url, :previous_url

    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    def find(params)
      params = parse_params(params)
      response = Mailgun.submit :get, events_url, params
      parse_response(response)
      response["items"]
    end

    def next
      response = Mailgun.submit :get, next_url
      parse_response(response)
      response["items"]
    end

    private
    def parse_response(response)
      @next_url = build_url(response['paging']['next'])
      @previous_url = build_url(response['paging']['previous'])
    end

    def build_url(url)
      uri = URI.parse(url)
      uri.userinfo = "api:#{Mailgun.api_key}"
      uri.to_s
    end

    def events_url
      "#{@mailgun.base_url}/#{@domain}/events"
    end

    def parse_params(params)
      [:begin, :end].each do |key|
        if params[key]
          params[key] = Time.parse(params[key].to_s).rfc2822
        end
      end
      params
    end

  end
end
