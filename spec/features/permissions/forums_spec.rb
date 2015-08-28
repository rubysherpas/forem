require 'spec_helper'

describe 'forum permissions' do
  let!(:forum) { FactoryGirl.create(:forum) }
  let!(:topic) { FactoryGirl.create(:topic, :forum => forum) }

  it "can't see forums it can't access" do
    allow_any_instance_of(User).to receive(:can_read_forem_forums?).and_return(false)
    visit forums_path
    expect(page).not_to have_content("Welcome to Forem!")
  end

  context "without ability to read all forums" do
    before do
      allow_any_instance_of(User).to receive(:can_read_forem_forums?).and_return(false)
    end

    it "is denied access" do
      visit forum_path(forum.id)
      access_denied!
    end
  end

  context "without ability to read a specific forum" do
    before do
      allow_any_instance_of(User).to receive(:can_read_forem_category?).and_return(true)
      allow_any_instance_of(User).to receive(:can_read_forem_forum?).and_return(false)
    end

    it "is denied access" do
      visit forum_path(forum.id)
      access_denied!
    end

    it "cannot view topics inside this forum" do
      visit forum_topic_path(forum, topic)
      access_denied!
    end
  end

  context "without ability to read a specific forum's category" do
    before do
      allow_any_instance_of(User).to receive(:can_read_forem_category?).and_return(false)
    end

    it "is denied access" do
      visit forum_path(forum.id)
      access_denied!
    end
  end

  context "with default permissions" do
    before do
      visit forum_path(forum.id)
    end

    it "shows the title" do
      within("#forum h2") do
        expect(page).to have_content("Welcome to Forem!")
      end
      within("#forum #description") do
        expect(page).to have_content("A placeholder forum.")
      end
    end
  end
end
