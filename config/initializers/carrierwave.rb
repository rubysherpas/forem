CarrierWave.configure do |config|
  config.fog_credentials = { 
    :provider                 => 'AWS',
    :aws_secret_access_key    => CONFIG.aws_secret_access_key,
    :aws_access_key_id        => CONFIG.aws_access_key_id,
    :region                   => CONFIG.aws_region
  }
  config.fog_directory = CONFIG.aws_s3_bucket
end
