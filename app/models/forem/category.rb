require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    has_many :category_subscriptions
    has_many :forums
    validates :name, uniqueness: { case_sensitive: false}, presence: true
    validates :position, numericality: { only_integer: true }

    scope :by_position, -> { order(:position) }

    before_validation :strip_whitespace
    before_destroy :check_forums, prepend: true

    def to_s
      name
    end

    def subscribe_user(subscriber_id)
      if subscriber_id && !subscribed?(subscriber_id)
        category_subscriptions.create!(monitor_id: subscriber_id)
      end
    end

    def unsubscribe_user(subscriber_id)
      category_subscriptions.find_by(monitor_id: subscriber_id).destroy
    end

    def subscribed?(subscriber_id)
      category_subscriptions.find_by(monitor_id: subscriber_id) ? true : false
    end

    private

    def strip_whitespace
      self.name = self.name.strip
    end

    def check_forums
      errors.add :forums, 'Category isn\'t empty' if forums.present?

      errors.blank?
    end
  end
end
