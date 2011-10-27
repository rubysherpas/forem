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
end
