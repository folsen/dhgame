class Material < ActiveRecord::Base
  belongs_to :task
  
  has_attached_file :data,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :s3_bucket_permissions => "private",
                    :s3_protocol => "http",
                    :path => ":basename.:extension",
                    :bucket => 'dhgame'
                    
  def example_usage
    if data_content_type[0..4] == "image"
      return '&lt;a href=&quot;' + self.data.url.split('?')[0] + '&quot;&gt;&lt;img width=&quot;400&quot; src=&quot;' + self.data.url.split('?')[0] + '&quot;/&gt;&lt;/a&gt;'
    else
      return '&lt;!-- ' + self.data.url.split('?')[0] + ' --&gt;'
    end
  end
  
end
