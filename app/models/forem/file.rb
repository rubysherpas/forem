module Forem
  class File < ActiveRecord::Base
    validates :file, presence: true

    delegate :path, :url, to: :file, prefix: true

    mount_uploader :file, ForemFileUploader

    belongs_to :owner, polymorphic: true

    def to_s
      'TODO fix it'
    end
  end
end
