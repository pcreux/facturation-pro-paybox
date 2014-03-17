#encoding: utf-8
require 'spec_helper'
require 'open-uri'

describe PayboxAttributes, '#full_url' do
  let(:pb) {
    PayboxAttributes.new(total: 1500, cmd: "2013-02", email: "pcreux@gmail.com")
  }

  it "should work against the gateway" do
    pending "Unpend when things go wrong..."
    response = open(pb.full_url).read
    begin
      response.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      response.should_not include 'attention'
    rescue
      puts response
      raise $!
    end
  end
end
