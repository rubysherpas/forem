module Forem
  module MigrationMacros
    def cleanup_migrations!
      Dir.chdir(Rails.root) do
        FileUtils.rm_rf("db/migrate")
      end
    end
  end
end

RSpec.configure do |c|
  c.include Forem::MigrationMacros, :example_group => {
    :file_path => c.escaped_path(%w[spec (migrations)])
  }
end