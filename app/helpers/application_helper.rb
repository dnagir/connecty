module ApplicationHelper
  def connecty_css_url
    uri = URI.parse(request.url)
    uri.merge(javascript_path('/stylesheets/widgets/tab.css'))
  end

  def connecty_javascript_url
    uri = URI.parse(request.url)
    uri.merge(javascript_path('/javascripts/widgets/tab.js'))
  end

  def connecty_install_script(project)
    return '' unless project
    <<SCRIPT_TAG
      <link href="#{connecty_css_url}" media="screen" rel="stylesheet" type="text/css" />
      <!-- ADD THIS IF YOUR PAGE DOES NOT USE JQUERY
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>
      -->
      <script type='text/javascript'>
        ConnectyOptions = {
          project: '#{inline_project_url(project)}'
        };
      </script>
      <script id='connecty-script-init' type="text/javascript" src='#{connecty_javascript_url}'></script>
SCRIPT_TAG
  end
end
