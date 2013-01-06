require 'spec_helper'

describe "forums" do
  let!(:forum) { FactoryGirl.create(:forum) }

  it "listing all" do
    visit forums_path
    within(".forum") do
      page.should have_content("Welcome to Forem!")
      within(".description") do
        page.should have_content("A placeholder forum.")
      end
    end
  end

  # Regression test for #352
  context "can include Markdown within a forum's description" do
    before {
      # MRI-specific C-extention tests
      if RUBY_VERSION < "1.9" || RUBY_ENGINE == "ruby"
        Forem.formatter = Forem::Formatters::Redcarpet
      else
        Forem.formatter = Forem::Formatters::Kramdown
      end
    }
    after { Forem.formatter = nil }

    it "includes a strong tag in a description" do

      forum.update_column(:description, "The **best** forum!")
      visit forums_path
      within(".forum") do
        assert find(".description").has_css?("strong")
      end

      visit forum_path(forum)
      within("#forum") do
        assert find("#description").has_css?("strong")
      end
    end
  end

  context "visiting a forum" do
    before do
      @topic_1 = FactoryGirl.create(:approved_topic, :subject => "Unpinned", :forum => forum)
      @topic_2 = FactoryGirl.create(:approved_topic, :subject => "Most Recent", :forum => forum)
      @topic_2.update_attribute(:last_post_at, Time.now + 30.seconds)
      @topic_3 = FactoryGirl.create(:approved_topic, :subject => "PINNED!", :forum => forum, :pinned => true)
      @topic_4 = FactoryGirl.create(:approved_topic, :subject => "HIDDEN!", :forum => forum, :hidden => true)
      visit forum_path(forum)
    end

    it "lists pinned topics first" do
      # TODO: cleaner way to get at topic subjects on the page?
      topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .subject").map(&:text)
      topic_subjects.should == ["PINNED!", "Most Recent", "Unpinned"]
    end

    it "does not show hidden topics" do
      # TODO: cleaner way to get at topic subjects on the page?
      topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .subject").map(&:text)
      topic_subjects.include?("HIDDEN!").should be_false
    end

    context "when logged in" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
      end

      # Regression test for #272
      context "when forem_state is pending_review" do
        let(:topic) { FactoryGirl.create(:topic, :forum => forum, :user => @user) }
        let(:other_user) { FactoryGirl.create(:user, :login => "other_user") }
        let(:other_topic) { FactoryGirl.create(:topic, :subject => "topic started by other_user with forem_state pending_review", :forum => forum, :user => other_user) }

        it "should show topic if logged in user has started topic" do
          visit forum_path(forum)

          page.all(".topics .topic .started-by").each do |div|
            div.should have_content("forem_user")
          end
        end

        it "should not show topic if other user has started topic" do
          visit forum_path(forum)

          # FIXME: capybara 2.0 / ruby 1.8.7 issue
          # page.all(".topics .topic .started-by").each do |div|
          #   div.should_not have_content("other_user")
          # end
          page.html.should_not match("other_user")
        end

        it "should show topic if logged in user is forem_admin" do
          @user.forem_admin = true
          visit forum_path(forum)
          assert_seen("forem_user")
        end
      end

      it "calls out topics that have been posted to since your last visit, if you've visited" do
        visit forum_topic_path(forum.id, @topic_2)
        ::Forem::View.last.update_attribute(:updated_at, 1.minute.ago)
        visit forum_path(forum)
        topic_subjects = Nokogiri::HTML(page.body).css(".topics tbody tr .new_posts")
        topic_subjects.should_not be_empty
      end

      context "checking new topics" do
        before do
          forum.register_view_by(@user)
          forum.view_for(@user).update_attribute(:past_viewed_at, 3.days.ago)
          @topic_1.created_at = 1.day.ago
          @topic_2.created_at = 1.day.ago
          @topic_3.created_at = 1.day.ago
          @topic_4.created_at = 4.days.ago
        end

        it "calls out new topics since last visit" do
          visit forum_path(forum)
          new_topics = Nokogiri::HTML(page.body).css(".topics tbody tr super")
          new_topics.size.should eq(3)
        end

        it "doesn't call out a topic that has been viewed" do
          visit forum_path(forum)
          visit forum_topic_path(forum, @topic_1)
          visit forum_path(forum)
          new_topics = Nokogiri::HTML(page.body).css(".topics tbody tr super")
          new_topics.size.should eq(2)
        end
      end
    end
  end
end
