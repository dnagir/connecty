class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :pick_layout

  protected
    def pick_layout
      params[:inline] == 'true' ? 'inline' : 'application'
    end
end
