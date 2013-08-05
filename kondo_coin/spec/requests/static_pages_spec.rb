require 'spec_helper'

describe "StaticPages" do
 
  let(:basetitle) { "Kondoco.in" }

  describe "Home page" do

    it "should habe the content 'KondoCoin'" do
      visit '/static_pages/home'
      expect(page).to have_content('KondoCoin')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{basetitle} | Home")
    end

  end # Describe home page

  describe "About page" do

    it "should habe the content 'KondoCoin'" do
      visit '/static_pages/about'
      expect(page).to have_content('KondoCoin')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("#{basetitle} | About")
    end

  end # Describe about page

end
