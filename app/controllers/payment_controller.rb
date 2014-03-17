class PaymentController < ApplicationController
  include Paybox::System::Rails::Integrity

  def callback
    check_paybox_integrity!
    if params.fetch(:error) == "00000"
      mark_invoice_as_paid(params.fetch(:reference))
    else
      notify_paybox_error
    end

    render text: ''
  end

  def success
    if params.fetch(:error) == "00000"
      render "success"
    else
      notify_paybox_error
      render_home warning: "Une erreur est survenue lors du paiement."
    end
  end

  def canceled
    render_home warning: "Le paiement de la facture a été annulé."
  end

  def refused
    render_home warning: "Le paiement de la facture a été refusé."
  end

  private

  def render_home(message)
    @reference = params[:reference]
    @amount    = params[:amount].to_f / 100.0 if params[:amount]

    flash.now[message.keys.first] = message.values.first
    render 'home/index'
  end

  def mark_invoice_as_paid(reference)
    @invoice = Invoice.find_by_reference(reference)
    @invoice.pay!(params[:autorization])
  end

  def notify_paybox_error
    begin
      raise "PayBox Error: #{params.fetch(:error)}"
    rescue => e
      Airbrake.notify e
    end
  end
end
