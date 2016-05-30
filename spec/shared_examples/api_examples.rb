shared_examples 'an API show request' do
  subject { response }

  describe 'with a valid ID' do
    it { should be_ok }
  end

  describe 'from an unauthenticated user' do
    let(:user) { nil }

    # forums are public by default
    it { should be_ok }
  end

  describe 'from an unauthorized user' do
    let(:authorized?) { false }

    # some forums are private
    it { should be_forbidden }
  end
end

shared_examples 'an API create request' do
  subject { response }

  describe 'with valid data' do
    it { should have_http_status(:created) }

    it 'provides a URL for the new post' do
      expect(URI.parse(response.location).path).to eq new_resource_url
    end
  end

  describe 'with no data' do
    let(:attributes) { {} }

    it { should be_bad_request }
  end

  describe 'with invalid data' do
    let(:attributes) { invalid_attributes }

    it { should be_bad_request }

    it 'returns error objects' do
      expect(errors).not_to be_blank
      expect(errors.first[:title]).to eq invalid_attributes_message
    end
  end

  describe 'with a client-generated ID' do
    let(:input_data) {
      {type: data_type, id: 'generated-ID', attributes: attributes}
    }

    it { should be_forbidden }
  end

  describe 'from an unauthenticated user' do
    let(:user) { nil }

    it { should be_forbidden }
  end

  describe 'from an unauthorized user' do
    let(:authorized?) { false }

    it { should be_forbidden }
  end
end

shared_examples 'an API update request' do
  subject { response }

  describe 'with valid data' do
    it { should be_ok }
  end

  describe 'with no data' do
    let(:attributes) { {} }

    it { should be_bad_request }
  end

  describe 'with invalid data' do
    let(:attributes) { invalid_attributes }

    it { should be_bad_request }

    it 'returns error objects' do
      expect(errors).not_to be_blank
      expect(errors.first[:title]).to eq invalid_attributes_message
    end
  end

  describe 'with an updated ID' do
    let(:input_data) {
      {type: data_type, id: model.id + 1, attributes: attributes}
    }

    it { should have_http_status(:conflict) }
  end

  describe 'from an unauthenticated user' do
    let(:user) { nil }

    it { should be_forbidden }
  end

  describe 'from an unauthorized user' do
    let(:authorized?) { false }

    it { should be_forbidden }
  end
end
