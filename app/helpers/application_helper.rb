module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

def is_current? tab
	case tab
	when 'home'
		request.path.eql?('/')
	when 'working'
		request.path.eql?('/pages/how_it_works')
	when 'faqs'
		request.path.eql?('/pages/faqs')
	when 'impact'
		request.path.eql?('/impact') or request.path.eql?('/preferences')
	when 'community'
		request.path.eql?('/community') or /^\/users\/\d+/.match(request.path)
	end
  end

  def mark_if_current tab
	'class="current"' if is_current? tab
  end

  def context_box_color
	['/', '/pages/faqs', '/pages/how_it_works'].include?(request.path) ? 'yellow' : 'green'
  end

end
