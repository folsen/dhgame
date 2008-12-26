class Material < ActiveRecord::Base
  belongs_to :task
  
  has_attached_file :data,
                    :url  => "/assets/:basename.:extension",
                    :path => ":rails_root/public/assets/:basename.:extension"
                    
  def example_usage
    if data_content_type[0..4] == "image"
      return '&lt;a href=&quot;/assets/' + data_file_name + '&quot;&gt;&lt;img width=&quot;400&quot; src=&quot;/assets/' + data_file_name + '&quot;/&gt;&lt;/a&gt;'
    else
      return '&lt;!-- /assets/' + data_file_name + ' --&gt;'
    end
  end
  
end
