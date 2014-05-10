class Site < ActiveRecord::Base
  REGIONS = %w(us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1)
  THEMES = Rails.root.join('themes').children.map {|i| i.basename.to_s }

  belongs_to :user
  has_many :pages
  validates :name, presence: true, length: { maximum: 50 }
  validates :theme, presence: true, inclusion: { in: THEMES }
  validates :s3_access_key, length: { maximum: 100 }
  validates :s3_secret_key, length: { maximum: 100 }
  validates :s3_region, inclusion: { in: REGIONS + [''] }

  def build_files
    build_path.mkdir unless build_path.exist?
    FileUtils.cp_r(theme_path + 'assets', build_path)
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
    upload(build_path)
  end

  def theme_path
    Rails.root.join('themes', theme)
  end

  private
    def upload(path)
      @s3 ||= Aws::S3.new(access_key_id: s3_access_key, secret_access_key: s3_secret_key, region: s3_region)
      path.each_child {|child|
        if child.directory? && child.children.length > 0
          upload(child)
        else
          key = child.to_s.remove(build_path.to_s).remove(%r!^/!)
          logger.info "Uploading to S3: #{child} -> #{key} (#{name})"
          body = File.read(child)
          mime = MimeMagic.by_magic(body).presence || MimeMagic.by_path(child)
          @s3.put_object(acl: 'public-read', bucket: name, key: key, body: body, content_type: mime.type)
        end
      }
    end

    def build_path
      Rails.root.join('build', name)
    end
end
