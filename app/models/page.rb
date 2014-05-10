class Page < ActiveRecord::Base
  belongs_to :site
  validates :title, presence: true, length: { maximum: 100 }
  validates :template, presence: true, length: { maximum: 100 }
  validates :path, presence: true, length: { maximum: 100 }
  validates :data, length: { maximum: 5000 }
end
