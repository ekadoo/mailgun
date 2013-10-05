require 'spec_helper'

describe Mailgun::Event do

  let(:mailgun) { Mailgun({:api_key => "api-key" }) }
  let(:events_url) { "http://mailgun.com/events/url" }
  let(:event) { Mailgun::Event.new(mailgun, "domain.com") }

  before do
    event.stub(:events_url =>  events_url)
    Mailgun::Event.should_receive(:new).and_return(event)
  end

  it "should have events" do
    mailgun.events.should eq(event)
  end

  describe "list events" do

    it "should make a GET request with correct params" do
      params = {:a => :b, :c => :d}
      Mailgun.should_receive(:submit).with(:get, events_url, params)
      mailgun.events.find(params)
    end

  end

end
