class Invoice < Facturation
  def self.find_by_reference(reference)
    raise "reference can't be nil!" if reference.blank?
    # reference 2014-06-1 returns invoices 2014-06-1.*
    all(params: {invoice_ref: reference}).
      select { |i| i.invoice_ref == reference }.first
  end

  def email
    Customer.find(customer_id).email
  end

  CREDIT_CARD_PAYMENT = 2

  # PATCH three attributes of the invoice
  def pay!(reference = nil, date=Time.now.to_date, mode=CREDIT_CARD_PAYMENT)
    attributes = { id: id, payment_ref: reference, paid_on: date.to_s, payment_mode: mode }
    # From activeresource/lib/base#update
    connection.patch(element_path(prefix_options), attributes.to_json, self.class.headers).tap do |response|
      load_attributes_from_response(response)
    end
  rescue
    raise $!.response.body
  end
end
