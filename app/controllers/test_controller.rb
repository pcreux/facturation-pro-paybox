class TestController < ApplicationController
  def form
    @paybox = PayboxAttributes.new(total: 1500, cmd: "Facture123", email: "pcreux@gmail.com")
  end

  def redirect
    @paybox = PayboxAttributes.new(total: 1500, cmd: "Facture123", email: "pcreux@gmail.com")
    redirect_to @paybox.full_url
  end
end
