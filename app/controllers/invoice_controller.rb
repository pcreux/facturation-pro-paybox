class InvoiceController < ApplicationController
  def pay
    @reference = params.fetch(:reference, "").strip
    @montant   = params.fetch(:montant, "").strip

    if @reference.blank? || @montant.blank?
      render_home notice: "Merci de renseigner les champs Référence et Montant TTC"
      return
    end

    amount = @montant.gsub(',', '.').to_f

    if amount == 0.0
      render_home notice: "Payer 0.00€? Vraiment? :)"
      return
    end

    FetchInvoice.call(@reference, amount,
      on_success:       ->(i) { redirect_to_paybox(amount, @reference, i.email) },
      not_found:        ->(i) { render_home alert:  "Facture non trouvée" },
      amount_mistmatch: ->(i) { render_home alert:  "Cette facture existe mais le montant ne correspond pas" },
      already_payed:    ->(i) { render_home notice: "Cette facture a déjà été payée" }
    )
  end

  private

  def render_home(message)
    flash.now[message.keys.first] = message.values.first
    render 'home/index'
  end

  def redirect_to_paybox(amount, reference, email)
    amount_in_cents = (amount * 100).to_i
    paybox = PayboxAttributes.new(total: amount_in_cents, cmd: reference, email: email)
    redirect_to paybox.full_url
  end
end
