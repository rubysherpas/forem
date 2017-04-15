if ENV['FOREM_LOCALEAPP_API_KEY'].present?
  Localeapp.configure do |config|
    config.polling_environments = [:development]
    config.reloading_environments = [:development]
    config.sending_environments = [:development]
    config.api_key = ENV['FOREM_LOCALEAPP_API_KEY']
  end
end
