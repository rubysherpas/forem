Dir[File.expand_path(File.dirname(__FILE__)) + "/factories/*.rb"].each do |f|
  require f
end