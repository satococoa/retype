class Page < ActiveRecord::Base
  belongs_to :site
  validates :title, presence: true, length: { maximum: 100 }
  validates :template, presence: true, length: { maximum: 100 }
  validates :path, presence: true, length: { maximum: 100 }
  validates :data, length: { maximum: 5000 }

  def render(context)
    parsed_data = JSON::parse(self.data)
    tmpl = Tilt.new(Rails.root.join('themes', site.theme, 'templates', template).to_s)
    layout = Tilt.new(Rails.root.join('themes', site.theme, 'layout.html.haml').to_s)
    context.render text: layout.render { tmpl.render(context, page: self, data: parsed_data) }
  end
end
