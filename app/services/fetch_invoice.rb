class FetchInvoice
  def self.call(reference, amount, callbacks)
    invoice = Invoice.find_by_reference(reference)

    if invoice.nil?
      callbacks.fetch(:not_found).call(invoice)
      return
    end

    if invoice.total_with_vat.to_f != amount
      callbacks.fetch(:amount_mistmatch).call(invoice)
      return
    end

    if invoice.paid_on
      callbacks.fetch(:already_payed).call(invoice)
      return
    end

    callbacks.fetch(:on_success).call(invoice)
  end
end

