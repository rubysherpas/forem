require 'spec_helper'

describe "forem/forums/_head.html.erb" do
  let(:user) { stub_model(User) }
  let(:forum) { FactoryGirl.create(:forum) }

  before do
    view.stub :forem_user => user
    view.stub :forem_emojify
    view.stub :forem_format

    controller.stub :current_ability => Forem::Ability.new(user)
    assign :forum, forum
  end

  context "users without the ability to create a new topic" do
    before do
      user.stub :can_create_forem_topics? => false
    end

    it "does not show a new topic link" do
      render :partial => "forem/forums/head", :locals => { :forum => forum }
      fragment = Nokogiri::HTML::DocumentFragment.parse(rendered)
      expect(fragment.css("#new-topic")).to be_empty
    end
  end

end