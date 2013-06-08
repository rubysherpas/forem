require File.expand_path('../../../app/presenters/forem/emoji_presenter', __FILE__)

class FakeContext
  def asset_path(image); image; end
end

module Forem
  describe EmojiPresenter do
    subject { EmojiPresenter.new(FakeContext.new, content) }
    context 'when there is emoji' do
      let!(:an_emoji) { Emoji.names.sample }
      let(:content) { "hello there I have :#{an_emoji}:" }
      it 'substitutes emoji syntax for an image' do
        subject.to_s.should include('<img')
        subject.to_s.should include("#{an_emoji}.png")
        subject.to_s.should_not include(":#{an_emoji}:")
      end
    end
    context 'when there is no emoji' do
      let(:content) { "hello there is no emoji here" }
      it 'returns the original content' do
        subject.to_s.should == content
      end
    end

  end
end
