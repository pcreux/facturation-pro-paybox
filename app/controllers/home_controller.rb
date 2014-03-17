class HomeController < ApplicationController
  def index
    @reference = params[:reference]
    @montant = params[:montant]
  end
end
