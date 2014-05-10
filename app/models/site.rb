class Site < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  validates :name, presence: true, length: { maximum: 50 }
  validates :theme, presence: true, length: { maximum: 100 }
  validates :s3_access_key, length: { maximum: 100 }
  validates :s3_secret_key, length: { maximum: 100 }

  def build_files
    build_path.mkdir unless build_path.exist?
    FileUtils.cp_r(theme_path + 'assets', build_path + 'assets')
    pages.each do |page|
      path = build_path.join(page.path.remove(%r!^/!))
      FileUtils.mkdir_p(path)
      File.open(path.join('index.html'), 'w') {|f|
        f.puts page.render(nil)
      }
    end
  end

  def deploy
    build_files
  end

  private
    def theme_path
      Rails.root.join('themes', theme)
    end

    def build_path
      Rails.root.join('build', name)
    end
end
