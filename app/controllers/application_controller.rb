class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :pick_layout

  protected
    def pick_layout
      inline? ? 'inline' : 'application'
    end

    def inline?
      params[:inline] == 'true'
    end

end
