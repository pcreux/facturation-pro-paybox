RSpec::Matchers.define :redirect_to_paybox do
  match do |actual|
    success = false

    begin
      actual.call
    rescue ActionController::RoutingError => e
      if e.message == 'No route matches [GET] "/cgi/MYchoix_pagepaiement.cgi"'
        success = true
      end
    end

    success
  end
end
