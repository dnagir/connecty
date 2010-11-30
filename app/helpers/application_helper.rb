module ApplicationHelper
  def connecty_css_url(path)
    uri = URI.parse(request.url)
    uri.merge(stylesheet_path path)
  end
  def connecty_javascript_url(path)
    uri = URI.parse(request.url)
    uri.merge(javascript_path path)
  end

  def connecty_install_script(project_id)
    <<SCRIPT_TAG
      <link href="#{connecty_css_url('widgets/tab.css')}" media="screen" rel="stylesheet" type="text/css" />
      <!-- ADD THIS IF YOUR PAGE DOES NOT USE JQUERY
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
      -->
      <script id='connecty-script-init' type="text/javascript" src='#{connecty_javascript_url("widgets/tab.js?project=#{project_id}")}'></script>
SCRIPT_TAG
  end
end
