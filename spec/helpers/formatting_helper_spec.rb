require 'spec_helper'

describe Forem::FormattingHelper do
  describe "as_formatted_html(text)" do
    let(:raw_html) {"<p>html</p>"}
    let(:text) {'three blind mice'}

    describe "unsafe html" do
      subject { helper.as_formatted_html(raw_html) }
      it "is escaped" do
        subject.should == ERB::Util.h(raw_html)
      end
      it {should be_html_safe}
    end

    describe "safe html" do
      subject { helper.as_formatted_html(raw_html.html_safe) }
      specify "is not escaped" do
        subject.should == raw_html
      end
      it {should be_html_safe}
    end
  end
end
