module ApiHelpers
  def api(method, action, params = {})
    send method, action, params,
      Accept: 'application/vnd.forem+json; version=1'
  end

  def included_objects_of_type(type)
    json[:included].select { |o| o[:type] == type }
  end
end

RSpec.configure do |c|
  c.include ApiHelpers, :type => :request
end
