module PageLayoutHelper
  def page_title(*titles)
    @page_title ||= []

    @page_title.push(*titles.compact) if titles.any?

    # Segments are seperated by middot
    @page_title.join(" \u00b7 ")
  end

  # Define or get a description for the current page
  #
  # description - String (default: nil)
  #
  # If this helper is called multiple times with an argument, only the last
  # description will be returned when called without an argument. Descriptions
  # have newlines replaced with spaces and all HTML tags are sanitized.
  #
  # Examples:
  #
  #   page_description # => "GitLab Community Edition"
  #   page_description("Foo")
  #   page_description # => "Foo"
  #
  #   page_description("<b>Bar</b>\nBaz")
  #   page_description # => "Bar Baz"
  #
  # Returns an HTML-safe String.
  def page_description(description = nil)
    @page_description ||= page_description_default

    if description.present?
      @page_description = description.squish
    else
      sanitize(@page_description, tags: []).truncate_words(30)
    end
  end

  # Default value for page_description when one hasn't been defined manually by
  # a view
  def page_description_default
    if @project
      @project.description || brand_title
    else
      brand_title
    end
  end

  def page_image
    default = image_url('gitlab_logo.png')

    if @project
      @project.avatar_url || default
    elsif @user
      avatar_icon(@user)
    else
      default
    end
  end

  def header_title(title = nil, title_url = nil)
    if title
      @header_title     = title
      @header_title_url = title_url
    else
      @header_title_url ? link_to(@header_title, @header_title_url) : @header_title
    end
  end

  def sidebar(name = nil)
    if name
      @sidebar = name
    else
      @sidebar
    end
  end

  def fluid_layout(enabled = false)
    if @fluid_layout.nil?
      @fluid_layout = (current_user && current_user.layout == "fluid") || enabled
    else
      @fluid_layout
    end
  end

  def blank_container(enabled = false)
    if @blank_container.nil?
      @blank_container = enabled
    else
      @blank_container
    end
  end

  def container_class
    css_class = "container-fluid"

    unless fluid_layout
      css_class += " container-limited"
    end

    if blank_container
      css_class += " container-blank"
    end

    css_class
  end
end
