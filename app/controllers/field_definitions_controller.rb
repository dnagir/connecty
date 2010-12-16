class FieldDefinitionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :project
  load_and_authorize_resource :field_definition, :through => :project
  
  def index
    @field_definitions = @project.field_definitions.order(:name)
  end

  def new
  end

  def create
    if @field_definition.save
      redirect_to project_field_definitions_url(@project), :notice => 'Custom field has been added.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @field_definition.update_attributes(params[:field_definition])
      redirect_to project_field_definitions_url(@project), :notice => 'Custom field has been added.'
    else
      render :new
    end
  end

  def destroy
    @field_definition.destroy
    redirect_to project_field_definitions_url(@project), :notice => 'Custom field has been added.'
  end
end
