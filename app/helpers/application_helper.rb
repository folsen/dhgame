# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def editable_content(options)
    options[:content] = { :element => 'span' }.merge(options[:content])
    options[:url] = {}.merge(options[:url])
    options[:ajax] = { :okText => "'Save'", :cancelText => "'Cancel'"}.merge(options[:ajax] || {})
    script = Array.new
    script << "new Ajax.InPlaceEditor("
    script << "  '#{options[:content][:options][:id]}',"
    script << "  '#{url_for(options[:url])}',"
    script << "  {"
    script << options[:ajax].map{ |key, value| "#{key.to_s}: #{value}" }.join(", ")
    script << "  }"
    script << ")"

    content_tag(
      options[:content][:element],
      options[:content][:text],
      options[:content][:options]
    ) + javascript_tag( script.join("\n") )
  end
  
  def select_with_integer_options (object, column, start, stop, default = nil)  
    output = "<select id=\"#{object}_#{column}\" name=\"#{object}[#{column}]\">"  
    for i in start..stop  
      output << "\n<option value=\"#{i}\""  
      output << " selected=\"selected\"" if i == default  
      output << ">#{i}"  
    end  
    output + "</select>"  
  end
  
  def home_link
    if User.active_user && User.active_user.admin != 1
      return link_to("Home", :controller => :task, :action => :index)
    elsif User.active_user && User.active_user.admin == 1
      return link_to("Home", :controller => :admin, :action => :index)
    else
      return link_to("Home", :controller => :public, :action => :index)
    end
  end
  
  def info_link
    if User.active_user
      return link_to("Rules & Info", :controller => :task, :action => :info)
    else
      return link_to("Rules & Info", :controller => :public, :action => :info)
    end
  end
    
  def help_link
    if User.active_user
      return link_to("Help", :controller => :task, :action => :help)
    else
      return link_to("Help", :controller => :public, :action => :help)
    end
  end
  
  def partial_path(task_object)
    path = "task/partials/task_#{task_object.partial}"
    logger.info(path)
    return path
  end
  
end
