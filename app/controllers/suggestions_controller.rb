class SuggestionsController < ApplicationController

  def create
    @project = Project.find(params[:project_id])
    @suggestion = @project.suggestions.build(params[:suggestion])
    if @suggestion.save
      additional = {}
      additional[:inline] = params[:inline] if params[:inline] == 'true'
      redirect_to project_path(@project, additional), :notice => 'Thanks. We appreciate your feedback.'
    else
      render :new
    end
  end

end
