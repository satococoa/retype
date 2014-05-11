class Site < ActiveRecord::Base
  REGIONS = %w(us-east-1 us-west-1 us-west-2 eu-west-1 ap-southeast-1 ap-southeast-2 ap-northeast-1 sa-east-1)
  THEMES = Rails.root.join('themes').children.select(&:directory?).map {|i| i.basename.to_s }

  enum deploy_type: [:s3, :ftp]

  belongs_to :user
  has_many :pages
  validates :name, presence: true, length: { maximum: 50 }
  validates :theme, presence: true, inclusion: { in: THEMES }
  validates :s3_access_key, length: { maximum: 100 }
  validates :s3_secret_key, length: { maximum: 100 }
  validates :s3_region, inclusion: { in: REGIONS + [''] }
  validates :ftp_host, length: { maximum: 100 }
  validates :ftp_directory, length: { maximum: 100 }
  validates :ftp_user, length: { maximum: 100 }
  validates :ftp_password, length: { maximum: 100 }


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
    if deploy_type == 's3'
      uploaded_keys = upload(build_path)
      remove(uploaded_keys)
    elsif deploy_type == 'ftp'
      logger.info "Syncing with FTP: #{build_path} -> #{ftp_directory}"
      ftp = FtpSync.new(ftp_host, ftp_user, ftp_password, passive: true)
      ftp.push_dir build_path, ftp_directory
    end
  end

  def theme_path
    Rails.root.join('themes', theme)
  end

  private
    def s3
      @s3 ||= Aws::S3.new(access_key_id: s3_access_key, secret_access_key: s3_secret_key, region: s3_region)
    end

    def upload(path, uploaded_keys = [])
      path.each_child {|child|
        if child.directory? && child.children.length > 0
          uploaded_keys += upload(child, uploaded_keys)
        else
          key = child.to_s.remove(build_path.to_s).remove(%r!^/!)
          uploaded_keys << key
          logger.info "Uploading to S3: #{child} -> #{key} (#{name})"
          body = File.read(child)
          mime = MimeMagic.by_magic(body).presence || MimeMagic.by_path(child)
          s3.put_object(acl: 'public-read', bucket: name, key: key, body: body, content_type: mime.type)
        end
      }
      uploaded_keys
    end

    def remove(not_remove_keys)
      existing_keys = s3.list_objects(bucket: 'demo.retype.jp').contents.map(&:key).reject{|key| key.match(/^logs/)}
      (existing_keys - not_remove_keys).each {|key|
        logger.info "Deleting from S3: #{key} (#{name})"
        s3.delete_object(bucket: name, key: key)
      }
    end

    def build_path
      Rails.root.join('build', name)
    end
end
