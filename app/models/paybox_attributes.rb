class PayboxAttributes
  include Virtus.model

  attribute :total,   String # en centimes
  attribute :cmd,     String # reference commande
  attribute :porteur, String # email acheteur
  attribute :devise,  String, default: "978" # euro

  def email=(email)
    self.porteur = email
  end

  def gateway_url
    ENV.fetch('PAYBOX_URL')
  end

  def params
    Paybox::System::Base.hash_form_fields_from(all_attributes)
  end

  def all_attributes
    config.merge(attributes)
  end

  def config
    {
      site:         ENV.fetch('PAYBOX_SITE'),
      rang:         ENV.fetch('PAYBOX_RANG'),
      identifiant:  ENV.fetch('PAYBOX_IDENTIFIANT'),
      paybox:       ENV.fetch('PAYBOX_URL'),
      backup1:      ENV.fetch('PAYBOX_BACKUP1'),
      backup2:      ENV.fetch('PAYBOX_BACKUP2'),
      effectue:     ENV.fetch('HOST_URL') + "/payment/success",
      refuse:       ENV.fetch('HOST_URL') + "/payment/refused",
      annule:       ENV.fetch('HOST_URL') + "/payment/canceled",
      repondre_a:   ENV.fetch('HOST_URL') + "/payment/callback",
      retour:       "amount:M;reference:R;autorization:A;error:E;sign:K",
      source:       "XHTML",
      typepaiement: "CARTE"
    }
  end

  def full_url
    gateway_url + '?' + get_params
  end

  def get_params
    formatted_options = Hash[all_attributes.map { |k, v| ["PBX_#{k.to_s.upcase}", v] }]
    formatted_options["PBX_HASH"] = "SHA512"

    date_iso = Time.now.utc.iso8601
    formatted_options["PBX_TIME"] = date_iso
formatted_options

    base_params_query = formatted_options.to_a.map { |a| a.join("=") }.join("&")
    # Escape...?
    #base_params_query = formatted_options.to_a.map { |a| a.map { |b| Rack::Utils.escape(b) }.join("=") }.join("&")

    key = Paybox::System::Base.config.fetch(:secret_key)

    binary_key = [key].pack("H*")
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha512'),
                  binary_key, base_params_query).upcase

    base_params_query = formatted_options.to_a.map { |a| a.map { |b| Rack::Utils.escape(b) }.join("=") }.join("&") + "&PBX_HMAC=#{signature}"
  end
end
