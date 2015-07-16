class ForemFileUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "uploads/forum/file/#{model.id}"
  end
end
