require 'spec_helper'

describe Forem::FormattingHelper do
  # This formatter uses the simple_format helper, which will um..
  # simply format things. Yes, that'll do.
  describe "as_formatted_html(text)" do
    let(:raw_html) {"<p>html</p>"}
    let(:text) {'three blind mice'}
    before { Forem.formatter = nil }

    describe "unsafe html" do
      subject { helper.as_formatted_html(raw_html) }
      it "is escaped" do
        subject.should == "<p>" + ERB::Util.h(raw_html) + "</p>"
      end
      it {should be_html_safe}
    end

    describe "safe html" do
      subject { helper.as_formatted_html(raw_html.html_safe) }
      specify "is not escaped" do
        subject.should == "<p>" + raw_html + "</p>"
      end
      it {should be_html_safe}
    end
  end

  describe "as_quoted_text" do
    let(:raw_html) {"<p>html</p>"}
    describe "default formatter" do
      before { Forem.formatter = nil }

      describe "unsafe html" do
        subject { helper.as_quoted_text(raw_html) }
        it "is escaped" do
          subject.should == "<blockquote>" + ERB::Util.h(raw_html) + "</blockquote>\n\n"
        end
        it {should be_html_safe}
      end

      describe "safe html" do
        subject { helper.as_quoted_text(raw_html.html_safe) }
        specify "is not escaped" do
          subject.should == "<blockquote>" + raw_html + "</blockquote>\n\n"
        end
        it {should be_html_safe}
      end
    end

    describe "Markdown" do
      let(:markdown) { "**strong text**" }
      before {
        # MRI-specific C-extention tests
        if RUBY_VERSION < "1.9" || RUBY_ENGINE == "ruby"
          Forem.formatter = Forem::Formatters::Redcarpet
        else
          Forem.formatter = Forem::Formatters::Kramdown
        end
      }

      describe "uses <blockquote> if no blockquote method" do
        subject { helper.as_quoted_text(markdown) }
        before { Forem.formatter.stub('respond_to?').with(:blockquote).and_return(false) }
        it "wraps the content in blockquotes" do
          subject.should == "<blockquote>#{markdown}</blockquote>\n\n"
        end
        it {should be_html_safe}
      end

      describe "uses formatter quoting method if exists" do
        subject { helper.as_quoted_text(raw_html) }
        before {
          Forem.formatter.stub('respond_to?').with(:blockquote).and_return(true)
          Forem.formatter.stub('respond_to?').with(:sanitize).and_return(false)

          Forem.formatter.stub(:blockquote).and_return("> #{markdown}")
        }

        it "quotes the original content" do
          subject.should == "> #{markdown}"
        end
        it {should be_html_safe}
      end

      describe "uses formatter sanitize method if exists" do
        subject { helper.as_formatted_html(markdown) }

        before {
          Forem.formatter.stub('respond_to?').with(:blockquote).and_return(false)
          Forem.formatter.stub('respond_to?').with(:sanitize).and_return(true)

          Forem.formatter.stub(:sanitize).and_return("sanitized it")
        }

        it {subject.should == "<p>sanitized it</p>"}

      end
    end
  end
end
