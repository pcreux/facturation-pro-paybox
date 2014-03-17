FacturationProPaybox::Application.routes.draw do
  root 'home#index'

  get '/facture', to: 'invoice#pay'
  %w(callback success canceled refused).each do |action|
    get "/payment/#{action}", to: "payment##{action}"
  end

  if Rails.env.development?
    get '/form', to: 'test#form'
    get '/redirect', to: 'test#redirect'
  end

end
