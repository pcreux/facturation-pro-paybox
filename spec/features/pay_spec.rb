require 'spec_helper'

describe "Pay" do
  context "when missing params" do
    it "displays error message" do
      visit '/facture?reference=123'
      page.should have_content "Merci de"
    end
  end

  context "when invalid params" do
    it "displays error message" do
      visit '/'
      fill_in :reference, with: ""
      fill_in :montant, with: ""
      click_button "Payer"

      page.should have_content "Merci de"
    end
  end

  context "when amount is 0" do
    it "displays error message" do
      visit '/'
      fill_in :reference, with: "whatever"
      fill_in :montant, with: "0"
      click_button "Payer"

      page.should have_content "Payer 0.00€? Vraiment? :)"
    end
  end

  context "when invoice does not exists" do
    use_vcr_cassette "invoice-does-not-exists"
    it "displays error message" do
      visit '/'
      fill_in :reference, with: "XXX"
      fill_in :montant, with: "1"
      click_button "Payer"

      page.should have_content "Facture non trouvée"
    end
  end

  context "when invoice matches" do
    context "when amount does not match" do
      use_vcr_cassette "amount-does-not-match"
      it "displays error message" do
        visit '/'
        fill_in :reference, with: "2014-1"
        fill_in :montant, with: "1"
        click_button "Payer"

        page.should have_content "Cette facture existe mais le montant ne correspond pas"
      end
    end
  end

  context "when invoice matches" do
    context "when invoice already paid yet" do
      use_vcr_cassette "invoice-already-paid"
      it "redirects to paybox" do
        visit '/'
        fill_in :reference, with: "2014-1"
        fill_in :montant, with: "21"
        click_button "Payer"

        page.should have_content "déjà été payée"
      end
    end

    context "when invoice not paid yet" do
      use_vcr_cassette "invoice-matches"
      it "redirects to paybox" do
        visit '/'
        fill_in :reference, with: "2014-2"
        fill_in :montant, with: "24"
        expect {
          click_button "Payer"
        }.to redirect_to_paybox
      end
    end
  end

end

