class SuggestionsController < ApplicationController

  def create
    @project = Project.find(params[:project_id])
    @suggestion = @project.suggestions.build(params[:suggestion])
    if @suggestion.save
      redirecting_to = params[:inline] == 'true' ? inline_project_url(@project) : project_path(@project)
      redirect_to redirecting_to, :notice => 'Thanks. We appreciate your feedback.'
    else
      render :new
    end
  end

  def edit    
  end
end
