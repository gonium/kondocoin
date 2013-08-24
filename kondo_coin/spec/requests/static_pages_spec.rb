require 'spec_helper'

describe "StaticPages" do
 
  let(:basetitle) { "Kondoco.in" }
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Buy your first bitcoins!')}
    it { should have_title("#{basetitle}")}
    it { should_not have_title('| Home') }
  end # Describe home page

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title("#{basetitle} | About")}
  end # Describe about page

  describe "Imprint page" do
    before { visit imprint_path }

    it { should have_content('Imprint') }
    it { should have_title("#{basetitle} | Imprint")}
  end # Describe contact page


end
