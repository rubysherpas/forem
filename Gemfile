source "https://rubygems.org"

gem 'forem-theme-base', :git => "git://github.com/radar/forem-theme-base"

gemspec

gem 'pry-rails'
gem 'pry-nav'

platforms :jruby do
  gem "activerecord-jdbc-adapter", :require => false
end

group :test do
  platforms :ruby do
    gem "forem-redcarpet"
    gem "mysql2"
    gem "pg"
    gem "sqlite3"
  end

  platforms :jruby do
    gem "activerecord-jdbcmysql-adapter", :require => false
    gem "activerecord-jdbcpostgresql-adapter", :require => false
    gem "activerecord-jdbcsqlite3-adapter", :require => false
    gem "forem-kramdown"
  end
end
