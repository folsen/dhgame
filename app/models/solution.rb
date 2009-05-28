class Solution < ActiveRecord::Base
  has_attached_file :pdf,
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :s3_bucket_permissions => "private",
                    :s3_protocol => "http",
                    :path => ":basename.:extension",
                    :bucket => 'dhgame'
end
