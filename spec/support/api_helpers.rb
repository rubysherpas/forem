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

RSpec.configure do |c|
  c.include ApiHelpers, :type => :request
end
