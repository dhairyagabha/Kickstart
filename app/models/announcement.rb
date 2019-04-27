class Announcement < ApplicationRecord
  TYPES = %w{ new fix update }

  after_initialize :set_defaults

  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :announcement_type, :description, :name, :published_at, presence: true
  validates :announcement_type, inclusion: { in: TYPES }


  def set_defaults
    self.published_at      ||= Time.zone.now
    self.announcement_type ||= TYPES.first
  end
end
