# -*- encoding : utf-8 -*-
# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, page_header = nil, show_title = true)
    page_header ||= page_title
    if params[:page].present? and params[:page].to_i > 1
      page_title = "第#{params[:page]}页_#{page_title}"
      page_header += " / 第#{params[:page]}页"
    end
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
    if show_title
      content_for(:header) { h(page_header.to_s) }      
    end
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  def meta(name,content)
    @meta ||= {}
    @meta[name] = content
    content_for(:head){
      "<meta name='#{name}' content='#{content}' />".html_safe
    }
  end
  def metalink rel,href
    content_for(:head){
      "<link rel='#{rel}' href='#{href}' />".html_safe
    }
  end
  def is_home? 
    request.url == root_url
  end
  def is_mainsite?
    !Subdomain.matches? request
  end
  def text_link_to text,url,options={}
    # "<tt class='text_link' longdesc='#{url}'>#{text}</tt>".html_safe
    
  end
  def js_external_link_to url
    "<script type='text/javascript'>
      document.write(\"<a href='#{url}' target='_blank' rel='nofollow'><img src='/assets/go.gif' /></a>\")
    </script>".html_safe
  end
  def js_write text
    "<script type='text/javascript'>
      document.write('#{escape_javascript text}')
    </script>".html_safe
  end
  
  def pint i
    i.to_i > 1 ? " - 第#{i}页" : nil
  end
  
  def next_page
    params[:page].to_i+1
  end
  def prev_page
    params[:page].to_i == 2 ? nil : params[:page].to_i-1
  end
  def kami_array num
    num = 400 if num > 400
    Kaminari::PaginatableArray.new([],:limit=>40,:offset=>40*(params[:page].to_i - 1),:total_count=>num)
  end
  
    def nofollow_sub str
    str.gsub(/<(a href="[^"]+?")>/,'<\1 rel="">').gsub(/rel\=\"/,"rel=\"nofollow ").html_safe
  end
  def jsemail(str)
    ('<SCRIPT TYPE="text/javascript">
emailE=("'+str.reverse+'").split("").reverse().join("");
document.write(\'<A href="mailto:\' + emailE + \'">\' + emailE + \'</a>\')
 //-->
</script>

<NOSCRIPT>
    <em>Email address protected by JavaScript.<BR>
    Please enable JavaScript to contact me.</em>
</NOSCRIPT>').html_safe
  end
  def js_link_to str,href
    "<a href='javascript://' onclick=goto('#{href.to_rev}',this)>#{str}</a>".html_safe
    # "<a href='javascript://' class='rl' data='#{href.to_rev}'>#{str}</a>".html_safe
  end
  def jslink str,href
    "<a href='javascript://' onclick=\"function(){this.href='#{href}'}\">#{str}</a>".html_safe
  end
  def js_link_to_with_class str,href,cls
    "<a href='javascript://' class=\"#{cls}\" onclick=goto('#{href.to_rev}',this)>#{str}</a>".html_safe
  end
  def js_write_link str,href
    str = link_to str,href,:rel=>"nofollow",:target=>"_blank"
    javascript_tag "document.write('#{str}')"
  end
  def bdad desc,id,js='c'
    "<script type=\"text/javascript\">\n/*#{desc}*/\nvar cpro_id = \"u#{id}\";\n</script>\n<script src=\"http://cpro.baidustatic.com/cpro/ui/#{js}.js\" type=\"text/javascript\"></script>".html_safe
  end
  def city_link name
    txt = File.read("#{Rails.root}/db/cities/ndrc.ac.cn")
    cities = JSON.parse txt
    return unless cities.has_key? name
    url = cities[name]
    ["#{name}黄页","http://www.ndrc.ac.cn/#{url}"]
  end
  def safe_print text
    text.gsub(/成人用品|性用品|性福|情趣/,'**') unless text.nil?
  end
  def js_reg *files
    logger.debug files
    content_for :footer do
      javascript_include_tag *files
    end
  end
end
