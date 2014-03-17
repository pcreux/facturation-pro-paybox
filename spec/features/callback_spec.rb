require 'spec_helper'

describe "callback" do
  context "when it works" do
    use_vcr_cassette "update-invoice"

    it "updates the invoice" do
      visit 'payment/callback?amount=1000&reference=2014-3&autorization=XXXXXX&error=00000&sign=HjE0NvaFWU6SK5UnxExHzPek37NHrTcV7db6yV5g0uMc7s7U6Vw3zgPIEPkj7RdrWFwGpgFCCAPPhqu6Mgy%2F32cx%2BxsdTEVPIyxGI69HU4muycdMCTg0roKW78kUOtUYZnYuegIJbP8ThrQE6kYZMfIoep7IQLXZ2etKMCh4VNQ%3D'
      page.body.should == ""
    end
  end

  context "when sign is invalid" do
    it "raises an exception" do
      expect {
        visit 'payment/callback?amount=1000&reference=2014-3&autorization=XXXXXX&error=00000&sign=INVALID'
      }.to raise_error 'Bad Paybox integrity test'
    end
  end

  it "displays success page" do
    visit 'payment/success?amount=1000&reference=2014-3&autorization=XXXXXX&error=00000&sign=HjE0NvaFWU6SK5UnxExHzPek37NHrTcV7db6yV5g0uMc7s7U6Vw3zgPIEPkj7RdrWFwGpgFCCAPPhqu6Mgy%2F32cx%2BxsdTEVPIyxGI69HU4muycdMCTg0roKW78kUOtUYZnYuegIJbP8ThrQE6kYZMfIoep7IQLXZ2etKMCh4VNQ%3D'
    page.should have_content "Merci"
  end

  it "displays success with error page" do
    visit 'payment/success?amount=1000&reference=2014-3&autorization=XXXXXX&error=00001&sign=HjE0NvaFWU6SK5UnxExHzPek37NHrTcV7db6yV5g0uMc7s7U6Vw3zgPIEPkj7RdrWFwGpgFCCAPPhqu6Mgy%2F32cx%2BxsdTEVPIyxGI69HU4muycdMCTg0roKW78kUOtUYZnYuegIJbP8ThrQE6kYZMfIoep7IQLXZ2etKMCh4VNQ%3D'
    page.should have_content "Une erreur"
  end

  it "displays canceled with error page" do
    visit 'payment/canceled'
    page.should have_content "annulé"
  end

  it "displays refused with error page" do
    visit 'payment/refused'
    page.should have_content "refusé"
  end
end
