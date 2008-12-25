class Material < ActiveRecord::Base
  belongs_to :task
  
  has_attached_file :data, :styles => { :small => "150x150>", :medium => "400x400>" },
                    :url  => "/assets/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/:style/:basename.:extension"
  
  def link(size)
    if data_content_type == "image/jpg"
      return image_tag data.url(size)
    else
      return link_to data.url
    end
  end
end
