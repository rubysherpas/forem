module Forem
  class Category < ActiveRecord::Base
    include ::Forem::UrlSlug

    has_many :forums
    validates :name, :presence => true

    def to_s
      name
    end

  end
end
