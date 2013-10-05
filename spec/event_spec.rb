require 'spec_helper'

describe Mailgun::Event do

  let(:mailgun) { Mailgun({:api_key => "api-key" }) }
  let(:events_url) { "https://example.mailgun.org/domain.com/events" }
  let(:event) { Mailgun::Event.new(mailgun, "domain.com") }

  let(:result) { JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures/events.json'))) }
  let(:last_result) do
    last_result = result.dup
    last_result["items"] = []
    last_result
  end

  before do
    mailgun.stub(:base_url => "https://example.mailgun.org/")
    event.stub(:mailgun =>  mailgun)
    Mailgun::Event.should_receive(:new).and_return(event)
    Mailgun.stub(:submit).and_return(result)
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

    it "should be able to fetch next page" do
      mailgun.events.find({})
      Mailgun.should_receive(:submit).with(:get, result['paging']['next'])
      mailgun.events.next
    end

    it "should be able to fetch one more next page" do
      mailgun.events.next
      Mailgun.should_receive(:submit).with(:get, result['paging']['next'])
      mailgun.events.next
    end

    it "should convert begin & end dates to RFC2822 if they are Time objects" do
      now = Time.now
      params = { :begin => now, :end => now + 100, :a => :b }
      Mailgun.should_receive(:submit).with(:get, events_url, {:begin => now.rfc2822, :end => (now + 100).rfc2822, :a => :b})
      mailgun.events.find(params)
    end

    it "should convert begin & end dates to RFC2822 if they are strings " do
      now = Time.now
      params = { :begin => now.to_s, :end => (now + 100), :a => :b }
      Mailgun.should_receive(:submit).with(:get, events_url, {:begin => now.rfc2822, :end => (now + 100).rfc2822, :a => :b})
      mailgun.events.find(params)
    end

  end

end
