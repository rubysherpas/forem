require 'spec_helper'
require 'generators/forem/views_generator'

describe Forem::Generators::ViewsGenerator do
  let(:views) { Rails.root + "app/views" }

  # Ensure directory is missing before generator is running
  before { FileUtils.rm_rf(views + "forem") }
  # And clean up once we are done
  after { FileUtils.rm_rf(views + "forem") }

  it "copies over files" do
    described_class.start(['--quiet'], :destination_root => Rails.root)
    dirs = ["forem", "forem/admin", "forem/forums", "forem/posts", "forem/topics"]
    dirs.each do |dir|
      assert File.directory?(views + dir), "did not generate #{dir}"
    end
  end
end
