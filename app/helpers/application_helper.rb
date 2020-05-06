module ApplicationHelper


  def flash_class(level)
    case level
      when 'info' then "alert alert-info"
      when 'notice','success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end
  
end
