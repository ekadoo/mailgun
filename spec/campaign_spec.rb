require 'spec_helper'

describe Mailgun::Campaign do

  before :each do
    @mailgun = Mailgun({:api_key => "api-key"})   # used to get the default values

    @sample_capaign = {
      :id => "1",
      :name => "Test Campaign 1"
    }
    @sample = {
      :email  => "test@sample.mailgun.org",
      :name   => "test",
      :domain => "sample.mailgun.org"
    }
  end

  describe "add campaign" do
    it "should make a POST response with the right params" do
      sample_response = "{\"name\": \"Test Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url)

      Mailgun.should_receive(:submit).with(:post, campaigns_url, {:name => @sample_capaign[:name], :id => @sample_capaign[:id]}).and_return(sample_response)
      @mailgun.campaigns.create(@sample_capaign[:name], @sample_capaign[:id])
    end
  end

  describe "list campaigns" do
    it "should make a GET request with the right params" do
      sample_response = "{\"total_count:\" 1, \"items:\" [{\"created_at\": \"Tue, 13 Feb 2013 21:11:51 GMT\", \"name\": \"Super Campaign\", \"id\": \"Custom ID\"}]}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url)

      Mailgun.should_receive(:submit).with(:get, campaigns_url, {}).and_return(sample_response)
      @mailgun.campaigns.list
    end

  end

  describe "find campaign" do
    it "should make a GET request with the right params" do
      sample_response = "{\"name\": \"Test Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url, "1")

      Mailgun.should_receive(:submit).with(:get, campaigns_url).and_return(sample_response)
      @mailgun.campaigns.find(1)
    end
  end

  describe "update campaign" do
    it "should make a PUT request with the right params" do
      sample_response = "{\"name\": \"Test Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url)

      Mailgun.should_receive(:submit).with(:post, campaigns_url, {:name => @sample_capaign[:name], :id => @sample_capaign[:id]}).and_return(sample_response)
      @mailgun.campaigns.create(@sample_capaign[:name], @sample_capaign[:id])

      sample_response = "{\"name\": \"Super Campaign 1\", \"id\": \"1\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url, "1")

      Mailgun.should_receive(:submit).with(:put, campaigns_url, {:name => "Super Campaign 1"})
      @mailgun.campaigns.update("1", {:name => "Super Campaign 1"})
    end

  end

  describe "delete campaign" do
    it "should make a DELETE request with the right params" do
      sample_response = "{\"message\": \"Campaign has been deleted\"}"
      campaigns_url = @mailgun.campaigns.send(:campaign_url, @sample_capaign[:id])

      Mailgun.should_receive(:submit).with(:delete, campaigns_url).and_return(sample_response)
      @mailgun.campaigns.delete(@sample_capaign[:id])
    end
  end

  describe "stats campaign" do
    it "should make a GET request with the right params" do
      sample_response = "{\"unique\":{\"clicked\":{\"link\":3,\"recipient\":3},\"opened\":{\"recipient\":3}},\"total\":{\"complained\":0,\"delivered\":67,\"clicked\":6,\"opened\":7,\"dropped\":0,\"bounced\":0,\"sent\":67,\"unsubscribed\":5}}"
      campaigns_stats_url = @mailgun.campaigns.send(:campaign_url, @sample_capaign[:id], 'stats')

      Mailgun.should_receive(:submit).with(:get, campaigns_stats_url).and_return(sample_response)
      @mailgun.campaigns.stats(@sample_capaign[:id])
    end
  end
  
  describe "events campaign" do
    it "should make a GET request with the right params" do
      sample_response = "[{\"domain\":\"mailgun.net\",\"tags\":[],\"timestamp\":\"Wed,15Feb201212:58:21GMT\",\"recipient\":\"baz@example.com\",\"event\":\"delivered\",\"user_vars\":{}},{\"domain\":\"mailgun.net\",\"tags\":[],\"timestamp\":\"Wed,15Feb201212:55:15GMT\",\"recipient\":\"baz@example.com\",\"event\":\"delivered\",\"user_vars\":{}}]"
      campaigns_events_url = @mailgun.campaigns.send(:campaign_url, @sample_capaign[:id], 'events')

      Mailgun.should_receive(:submit).with(:get, campaigns_events_url, {}).and_return(sample_response)
      @mailgun.campaigns.events(@sample_capaign[:id])
    end
  end

end
