require 'spec_helper'

describe Forem::FormattingHelper do
  describe "as_formatted_html(text)" do
    let(:raw_html) {"<p>html</p>"}
    let(:text) {'three blind mice'}

    describe "plain text" do
      subject {helper.as_formatted_html(text)}
      it "is wrapped with pre tag" do
        subject.should == '<pre>'+text+'</pre>'
      end
    end

    describe "unsafe html" do
      subject {helper.as_formatted_html(raw_html)}
      it "is escaped and wrapped with pre tag" do
        subject.should == '<pre>'+ERB::Util.h(raw_html)+'</pre>'
      end
      it {should be_html_safe}
    end

    describe "safe html" do
      subject {helper.as_formatted_html(raw_html.html_safe)}
      specify "is not escaped, but is wrapped with pre tag" do
        subject.should == '<pre>'+raw_html+'</pre>'
      end
      it {should be_html_safe}
    end
  end
end