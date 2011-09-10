require 'spec_helper'

describe Forem::Post do
  let(:post) { FactoryGirl.create(:post) }
  let(:reply) { FactoryGirl.create(:post, :reply_to => post) }
  
  context "upon deletion" do

    it "clears the reply_to_id for all replies" do
      reply.reply_to.should eql(post)
      post.destroy
      reply.reload
      reply.reply_to.should be_nil
    end
  end
end