module SourceFilesHelper
  def coverage_status_for_line(source_file, line_number)
    hit = source_file.hits_per_line(line_number)
    case hit
    when nil
      return "never"
    when 0
      return "missed"
    else
      return "covered"
    end
  end

  def badge_for_line(source_file, line_number)
    hits = source_file.hits_per_line(line_number)
    case hits
    when 0
      content_tag(:span, "!", class: "badge alert-danger")
    when nil
    else
      content_tag(:span, "#{hits}x", class: "badge alert-success")
    end
  end
end
