require 'spec_helper'

describe "StaticPages" do
 
  let(:basetitle) { "Kondoco.in" }
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('KondoCo.in')}
    it { should have_title("#{basetitle}")}
    it { should_not have_title('| Home') }
  end # Describe home page

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title("#{basetitle} | About")}
  end # Describe about page

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title("#{basetitle} | Contact")}
  end # Describe contact page


end
