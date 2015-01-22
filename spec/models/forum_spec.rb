require 'spec_helper'

describe Forem::Forum do
  let!(:forum) { FactoryGirl.create(:forum) }

  it "is valid with valid attributes" do
    forum.should be_valid
  end

  it "is scoped by default" do
    if ActiveRecord::Base.connection.class.to_s =~ /Mysql/
      Forem::Forum.all.to_sql.should =~ /ORDER BY `forem_forums`.`position` ASC/
    else
      Forem::Forum.all.to_sql.should =~ /ORDER BY \"forem_forums\".\"position\" ASC/
    end
  end

  describe "validations" do
    it "requires a name" do
      forum.name = nil
      forum.should_not be_valid
    end

    it "requires a description" do
      forum.description = nil
      forum.should_not be_valid
    end

    it "requires a category id" do
      forum.category_id = nil
      forum.should_not be_valid
    end
  end

  context "deletion" do
    it "deletes views" do
      FactoryGirl.create(:forum_view, :viewable => forum)
      forum.destroy
      Forem::View.exists?(:viewable_id => forum.id).should be_false
    end
  end

  describe "helper methods" do
    context "name" do
      it "is aliased to title" do
        forum.title = "foo"
        forum.name.should eq("foo")

        forum.name = 'bar'
        forum.title.should eq("bar")
      end

      context "to_s" do
        it 'returns the name of the forum' do
          forum.to_s.should == forum.name
        end
      end
    end

    # Regression tests + tests related to fix for #42
    context "last_post" do
      let!(:visible_topic) { FactoryGirl.create(:topic, :forum => forum) }
      let!(:hidden_topic) { FactoryGirl.create(:topic, :forum => forum, :hidden => true) }

      let(:user) { FactoryGirl.create(:user) }
      let(:admin) { FactoryGirl.create(:admin) }


      context "finding the last visible post for a user" do
        it "does not find non-approved posts" do
          forum.last_visible_post(user).should be_nil
        end

        context "with approved topic + post" do
          before do
            visible_topic.state = 'approved'
            visible_topic.posts.first.state = 'approved'
            visible_topic.save
          end

          it "finds the last post for a user" do
            forum.last_visible_post(user).should == visible_topic.posts.last
            # visible post doesn't contain hidden topics, duh
            forum.last_visible_post(admin).should == visible_topic.posts.last
          end
        end
      end

      context "finding the last post for a user" do
        it "does not find non-approved posts" do
          forum.last_post_for(user).should be_nil
        end

        context "with approved topic + post" do
          before do
            visible_topic.state = 'approved'
            visible_topic.posts.first.state = 'approved'
            visible_topic.save
          end

          it "finds the last post for a user" do
            # Due to a #lolmysql "feature", where two posts updated at
            # the same second are returned in the wrong order.
            hidden_topic.posts.last.update_column(:created_at, 1.minute.from_now)
            forum.last_post_for(user).should == visible_topic.posts.last
            forum.last_post_for(admin).should == hidden_topic.posts.last
          end
        end
      end
    end

    context "moderator?" do
      it "no user is no moderator" do
        forum.moderator?(nil).should be_false
      end

      it "is a moderator if group ids intersect" do
        forum.stub :moderator_ids => [1,2]
        user = double :forem_group_ids => [2,3]
        forum.moderator?(user).should be_true
      end

    end
  end
end
