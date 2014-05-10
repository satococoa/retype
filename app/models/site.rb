class Site < ActiveRecord::Base
  belongs_to :user
  validates :name, presence: true, length: { maximum: 50 }
  validates :s3_access_key, length: { maximum: 100 }
  validates :s3_secret_key, length: { maximum: 100 }
end
