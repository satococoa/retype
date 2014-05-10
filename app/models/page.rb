class Page < ActiveRecord::Base
  belongs_to :site
  validates :title, presence: true, length: { maximum: 100 }
  validates :template, presence: true, length: { maximum: 100 }
  validates :path, presence: true, length: { maximum: 100 }
  validates :data, length: { maximum: 5000 }

  def render(context)
    @data = JSON::parse(data)
    tilt = Tilt.new(Rails.root.join('themes', site.theme, 'templates', template).to_s)
    context.render text: tilt.render(context, page: self)
  end
end
