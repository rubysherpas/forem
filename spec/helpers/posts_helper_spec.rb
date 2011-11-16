require 'spec_helper'

module Forem
  describe PostsHelper do
    describe "#avatar_url" do
      let(:email) { "forem_test@example.com" }
      let(:email_hash) { Digest::MD5.hexdigest(email) }

      context "with only an email" do
        let(:opts) { {} }

        it 'includes the default size' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?s=60"
          helper.avatar_url(email, opts).should eq(expected)
        end
      end

      context 'with a size' do
        let(:opts) { {:size => 99} }

        it 'overwrites the default size' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?s=99"
          helper.avatar_url(email, opts).should eq(expected)
        end
      end

      context 'with a default' do
        let(:opts) { {:default => 'mm'} }

        it 'includes a default parameter' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?d=mm&s=60"
          helper.avatar_url(email, opts).should eq(expected)
        end
      end

      context 'with size and default' do
        let(:opts) { {:default => 'mm', :size => '99'} }

        it 'includes a default parameter and overwrites the default size' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?d=mm&s=99"
          helper.avatar_url(email, opts).should eq(expected)
        end
      end
    end
  end
end
