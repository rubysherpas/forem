require 'spec_helper'

describe Forem::ApplicationHelper do
  describe 'forem_pages_widget' do
    context 'with options' do
      context 'when using will_paginate' do
        it 'calls will_paginate with the options' do
          # Simulate an app using will_paginate
          allow(Forem::ApplicationHelper).to receive(:respond_to?).with(:will_paginate).and_return(true)
          allow(helper).to receive(:will_paginate).and_return('content')
          collection = double(Forem::Post, num_pages: 10, current_page: 1, total_pages: 3, limit_value: 1)

          helper.should_receive(:will_paginate).with(collection, test_option: :test)

          helper.forem_pages_widget(collection, test_option: :test)
        end
      end

      context 'when using kaminari' do
        it 'calls paginate with the options' do
          allow(helper).to receive(:paginate).and_return('content')
          collection = double(Forem::Post, num_pages: 10, current_page: 1, total_pages: 3, limit_value: 1)

          helper.should_receive(:paginate).with(collection, test_option: :test)

          helper.forem_pages_widget(collection, test_option: :test)
        end
      end
    end
  end
end
