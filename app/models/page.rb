class Page < ActiveRecord::Base
  belongs_to :site
  validates :title, presence: true, length: { maximum: 100 }
  validates :template, presence: true, length: { maximum: 100 }
  validates :path, presence: true, length: { maximum: 100 },
                   format: { with: %r!\A/! }
  validates :data, length: { maximum: 5000 }
  validate :template_exists

  def template_exists
    errors.add(:template, "should exist") unless templates.include?(template)
  end

  def render(context)
    parsed_data = JSON::parse(self.data)
    tmpl = Tilt.new(Rails.root.join('themes', site.theme, 'templates', template).to_s)
    layout = Tilt.new(Rails.root.join('themes', site.theme, 'layout.html.haml').to_s)
    layout.render { tmpl.render(context, page: self, data: parsed_data) }
  end

  def templates
    site.theme_path.join('templates').children.select{|path| path.to_s.match(%r!.+?\.html\..+!) }.map {|path| path.basename.to_s }
  end

  def default_data
    site.theme_path.join('data').children.select{|path| path.to_s.match(%r!.+?\.json!) }.inject({}) {|obj, path| obj[path.basename('.json').to_s] = path.read; obj}
  end
end
