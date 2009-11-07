module Admin::TasksHelper

  #add link for first argument, material or answer
  #params type = material || answer or the shit breaks
  def add_link(type, name)
    link_to_function name do |page|
      page << "$('#{type}s').grab($('empty-#{type}').getFirst().clone());"
    end
  end

  #create the fields declarations for a certain object
  def fields_for_object(object, &block)
    prefix = object.new_record? ? 'new' : 'existing'
    fields_for("task[#{prefix}_#{object.class.name.downcase}_attributes][]", object, &block)
  end

  #create a link for inserting proper html into the description box
  def insert_html_link(material)
    link_to_function material.data_file_name, "$('task_desc').value += '#{material.example_usage}'"
  end
end