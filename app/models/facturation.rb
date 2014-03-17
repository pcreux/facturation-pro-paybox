require 'active_resource'

class Facturation < ActiveResource::Base
  self.site = Rails.application.config.facturation_pro_url
  self.user = ENV.fetch('FACTURATION_USER')
  self.password = ENV.fetch('FACTURATION_PASSWORD')

  self.timeout = 15
  self.format = :json
  self.include_root_in_json = false

  def self.headers
    @headers ||= {}
    @headers['User-Agent'] ||= "Your user agent (agent@example.com)"
    @headers
  end
end
