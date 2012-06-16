require 'spec_helper'

describe Forem::Forum do
  before(:each) do
    category = FactoryGirl.create(:category)
    @attr = {
      :title => "A forum",
      :description => "My sweet forum of goodness",
      :category_id => category.id
    }
    @forum = Forem::Forum.create!(@attr)
  end
  
  it "is valid with valid attributes" do
    @forum.should be_valid
  end
  
  describe "validations" do
    it "requires a title" do
      @forum.title = nil
      @forum.should_not be_valid
    end

    it "requires a description" do
      @forum.description = nil
      @forum.should_not be_valid
    end

    it "requires a category id" do
      @forum.category_id = nil
      @forum.should_not be_valid
    end
  end

  describe "helper methods" do
    # Regression tests + tests related to fix for #42
    context "last_post" do
      let!(:visible_topic) { FactoryGirl.create(:topic, :forum => @forum) }
      let!(:hidden_topic) { FactoryGirl.create(:topic, :forum => @forum, :hidden => true) }

      let(:user) { FactoryGirl.create(:user) }
      let(:admin) { FactoryGirl.create(:admin) }


      context "finding the last visible post for a user" do
        it "does not find non-approved posts" do
          @forum.last_visible_post(user).should be_nil
        end

        context "with approved topic + post" do
          before do
            visible_topic.state = 'approved'
            visible_topic.posts.first.state = 'approved'
            visible_topic.save
          end

          it "finds the last post for a user" do
            @forum.last_visible_post(user).should == visible_topic.posts.last
            # visible post doesn't contain hidden topics, duh
            @forum.last_visible_post(admin).should == visible_topic.posts.last
          end
        end
      end

      context "finding the last post for a user" do
        it "does not find non-approved posts" do
          @forum.last_post_for(user).should be_nil
        end

        context "with approved topic + post" do
          before do
            visible_topic.state = 'approved'
            visible_topic.posts.first.state = 'approved'
            visible_topic.save
          end

          it "finds the last post for a user" do
            @forum.last_post_for(user).should == visible_topic.posts.last
            @forum.last_post_for(admin).should == hidden_topic.posts.last
          end
        end
      end
    end

    context "moderator?" do
      it "no user is no moderator" do
        @forum.moderator?(nil).should be_false
      end

      it "is a moderator if group ids intersect" do
        @forum.stub :moderator_ids => [1,2]
        user = stub :forem_group_ids => [2,3]
        @forum.moderator?(user).should be_true
      end

    end
  end
end
