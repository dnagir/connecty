var Connecty = function(){
  var $ = jQuery;
  var options = ConnectyOptions;  

  var getTabUrl = function() {
    return options.project + "?inline=true";
  }

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

  if (options && options.project) {
    $(document).ready(function(){
      $("<div class='connecty-tab-box'><a href='#' class='connecty-tab-content connecty-tab-trigger'>Feedback</a></div>")
        .appendTo('body').find('.connecty-tab-trigger').click(function(e) {
          e.preventDefault();
          openTab()
        });
    });
  }
}();
