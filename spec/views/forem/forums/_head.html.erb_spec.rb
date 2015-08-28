require 'spec_helper'

describe "forem/forums/_head.html.erb" do
  let(:user) { stub_model(User) }
  let(:forum) { FactoryGirl.create(:forum) }

  before do
    allow(view).to receive_messages :forem_user => user
    allow(view).to receive :forem_emojify
    allow(view).to receive :forem_format

    allow(controller).to receive_messages :current_ability => Forem::Ability.new(user)
    assign :forum, forum
  end

  context "users without the ability to create a new topic" do
    before do
      allow(user).to receive_messages :can_create_forem_topics? => false
    end

    it "does not show a new topic link" do
      render :partial => "forem/forums/head", :locals => { :forum => forum }
      fragment = Nokogiri::HTML::DocumentFragment.parse(rendered)
      expect(fragment.css("#new-topic")).to be_empty
    end
  end

end