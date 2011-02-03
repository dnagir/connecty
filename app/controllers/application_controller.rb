class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :pick_layout

  protected
    def pick_layout
      if inline?
        headers['P3P'] = 'CP="IDC DSP COR CURa ADMa OUR IND PHY ONL COM STA"'
        'inline'
      else
        'application'
      end
    end

    def inline?
      params[:inline] == 'true'
    end

    rescue_from CanCan::AccessDenied do |exception|
      flash[:alert] = exception.message
      redirect_to root_url # redirect to a page that has no redirects to preserve the flash message
    end
end
