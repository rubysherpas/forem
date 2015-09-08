require 'spec_helper'

describe "forem/posts/_post.html.erb" do
  let!(:user) { stub_model(User, :to_s => 'User') }
  let!(:forum) { stub_model(Forem::Forum) }
  let!(:topic) { stub_model(Forem::Topic, forum: forum) }
  let!(:post) { stub_model(Forem::Post, topic: topic, user: user) }

  before do
    allow(view).to receive_messages :forem_admin_or_moderator? => false
    allow(view).to receive_messages :post_time_tag => "Time goes here"
    allow(view).to receive_messages :forem_format => "Some text goes here"
    allow(view).to receive_messages :forem_user => user
    allow(controller).to receive_messages :current_ability => Forem::Ability.new(user)
  end

  context "edit link" do

    context "without permission to edit the post" do
      before do
        allow(user).to receive_messages :can_edit_forem_posts? => false
      end

      it "does not show a post edit link" do
        render :partial => "forem/posts/post", locals: { post: post, post_counter: 1}
        fragment = Nokogiri::HTML::DocumentFragment.parse(rendered)
        expect(
          fragment.css('a').any? { |a| a.text.include?("Editing post") }
        ).to eq(false)  
      end
    end

    context "with permission to edit the post" do
      it "shows a post edit link" do
        render :partial => "forem/posts/post", locals: { post: post, post_counter: 1}
        fragment = Nokogiri::HTML::DocumentFragment.parse(rendered)
        expect(
          fragment.css('a').any? { |a| a.text.include?("Editing post") }
        ).to eq(true)
      end
    end
  end

  context "delete link" do
    context "without permission to edit the post" do
      before do
        allow(user).to receive_messages :can_destroy_forem_posts? => false
      end

      it "does not show a delete link" do
        render :partial => "forem/posts/post", locals: { post: post, post_counter: 1}
        fragment = Nokogiri::HTML::DocumentFragment.parse(rendered)
        expect(
          fragment.css('a').any? { |a| a.text.include?("Delete") }
        ).to eq(false)  
      end
    end

    context "with permission to edit the post" do
      it "shows a delete link" do
        render :partial => "forem/posts/post", locals: { post: post, post_counter: 1}
        fragment = Nokogiri::HTML::DocumentFragment.parse(rendered)
        expect(
          fragment.css('a').any? { |a| a.text.include?("Delete") }
        ).to eq(true)
      end
    end
  end
end