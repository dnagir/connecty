var Connecty = function(){
  var $ = jQuery;

  var PRODUCTION_HOSTING_DOMAIN = 'localhost:3000';

  var getTabUrl = function() {
    var protocol = "https:" == document.location.protocol ? "https://" : "http://";
    return protocol + PRODUCTION_HOSTING_DOMAIN + "/projects/" + getProjectId() + "?inline=true";
  }

  var getProjectId = function() {
    var el = document.getElementById('connecty-script-init');
    if (!el) alert('Connecty incorrectly initialised. Must have script with id.');
    var id = el.src.match(/project=(\d+)/)[1];
    if (!id) alert('Connecty incorrectly initialised. Must have script with src="?project=123"');
    return id;
  };

  var hideTab = function() {
    $('.connecty-tab-area-overlay, .connecty-tab-area').remove();
  }

  var openTab = function() {
    hideTab();
    
    $('<div class="connecty-tab-area-overlay"></div>').appendTo('body');

    var $content = $('<div class="connecty-tab-area-content">').append(
      $('<iframe scrolling="yes" frameborder="0" allowtransparency="true"></iframe></div>').attr('src', getTabUrl())
    );
    var $tools = $("<div class='connecty-tab-area-toolbar'><a href='#' class='connecty-tab-tool-close'><span>Close</span></a></div>");
    $('<div class="connecty-tab-area"></div>')
      .append($tools)
      .append($content)
      .appendTo('body')
      .find('.connecty-tab-tool-close').click(function(e) { e.preventDefault(); hideTab(); });
  };

  $(document).ready(function(){

    $("<div class='connecty-tab-box'><a href='#' class='connecty-tab-content connecty-tab-trigger'>Feedback</a></div>")
      .appendTo('body').find('.connecty-tab-trigger').click(function(e) {
        e.preventDefault();
        openTab()
      });
  });
}();
