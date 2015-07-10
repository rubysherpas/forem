class ForemFileUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}_logo/#{model.id}"
  end
end
