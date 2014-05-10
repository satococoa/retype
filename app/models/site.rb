class Site < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  validates :name, presence: true, length: { maximum: 50 }
  validates :theme, presence: true, length: { maximum: 100 }
  validates :s3_access_key, length: { maximum: 100 }
  validates :s3_secret_key, length: { maximum: 100 }
end
