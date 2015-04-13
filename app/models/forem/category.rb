require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    has_many :forums
    validates :name, uniqueness: { case_sensitive: false}, presence: true
    validates :position, numericality: { only_integer: true }

    scope :by_position, -> { order(:position) }

    before_destroy :check_forums, prepend: true

    def to_s
      name
    end

    private

    def check_forums
      errors.add :forums, 'Category isn\'t empty' if forums.present?

      errors.blank?
    end
  end
end
