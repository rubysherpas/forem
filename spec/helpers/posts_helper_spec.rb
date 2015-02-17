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
          expect(helper.avatar_url(email, opts)).to eq(expected)
        end
      end

      context 'with a size' do
        let(:opts) { {:size => 99} }

        it 'overwrites the default size' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?s=99"
          expect(helper.avatar_url(email, opts)).to eq(expected)
        end
      end

      context 'with a default' do
        let(:opts) { {:default => 'mm'} }

        it 'includes a default parameter' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?d=mm&s=60"
          expect(helper.avatar_url(email, opts)).to eq(expected)
        end
      end

      context 'with size and default' do
        let(:opts) { {:default => 'mm', :size => '99'} }

        it 'includes a default parameter and overwrites the default size' do
          expected = "http://www.gravatar.com/avatar/#{email_hash}?d=mm&s=99"
          expect(helper.avatar_url(email, opts)).to eq(expected)
        end
      end

      context 'with any email and ssl' do
        let(:opts) { {} }

        it 'should have the secure url' do
          helper.request.env['HTTPS'] = 'on'
          expected = "https://secure.gravatar.com/avatar/#{email_hash}?s=60"
          expect(helper.avatar_url(email, opts)).to eq(expected)
        end
      end
    end

    describe "#default_gravatar" do
      it "returns the default_gravatar_image when an absolute URL is set" do
        url = "http://example.com/foo/bar.jpg"
        allow(Forem).to receive_messages(:default_gravatar_image => url)

        expect(helper.default_gravatar).to eq(url)
      end

      it "returns an absolute URL when default_gravatar image is set to a relative path" do
        image = "foo.jpg"
        allow(Forem).to receive_messages(:default_gravatar_image => image)

        expected = "http://test.host/images/foo.jpg"
        expect(helper.default_gravatar).to eq(expected)
      end

      it "returns the default_gravatar when set" do
        theme = 'mm'
        allow(Forem).to receive_messages(:default_gravatar => theme)

        expect(helper.default_gravatar).to eq(theme)
      end
    end
  end
end
