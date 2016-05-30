module ApiHelpers
  def json
    @json ||= JSON.parse(response.body).with_indifferent_access
  end

  def data
    json[:data]
  end

  def errors
    json[:errors]
  end

  def api(method, action, params = {})
    send method, action, params,
      Accept: 'application/vnd.forem+json; version=1'
  end

  def included_objects_of_type(type)
    json[:included].select { |o| o[:type] == type }
  end
end

RSpec::Matchers.define :have_http_status do |expected|
  match do |actual|
    actual.response_code == Rack::Utils::status_code(expected)
  end
end

RSpec::Matchers.define :reference_one do |relationship, (type, id)|
  define_method :related do
    actual[:relationships][relationship][:data] rescue nil
  end

  match do |actual|
    [related[:type], related[:id]] == [type, id] if related
  end

  failure_message do
    found = related ? "'#{related[:type]} #{related[:id]}'" : 'not found'

    "expected #{actual[:type]} #{actual[:id]} " +
      "to reference #{relationship} '#{type} #{id}'; " +
      "was #{found}"
  end
end

RSpec::Matchers.define :reference_many do |relationship, *expected_types_and_ids|
  define_method :related do
    actual[:relationships][relationship][:data] rescue nil
  end

  define_method :related_types_and_ids do
    related.map { |item| item.values_at(:type, :id) }
  end

  def sentence(types_and_ids)
    types_and_ids.map { |(type, id)| "'#{type} #{id}'" }.to_sentence
  end

  match do |actual|
    related && (related_types_and_ids.sort == expected_types_and_ids.sort)
  end

  failure_message do
    found = related ? sentence(related_types_and_ids) : 'not found'

    "expected #{actual[:type]} #{actual[:id]} " +
      "to reference #{relationship} #{sentence(expected_types_and_ids)}; " +
      "was #{found}"
  end
end

RSpec.configure do |c|
  c.include ApiHelpers, :type => :request
end
