class TagsController < ApplicationController

  def tag_params
    params.require(:tag).permit(:name, :description, :user_id, :budget)
  end

  def expens_tags_association_params
    params.require(:expens_tags_association).permit(:expense_id, :tag_id)
  end

  # GET /tags
  # GET /tags.json
  def index
    if current_user[:type_id] == 2
      @tags = Tag.includes(:user).order('name asc').load
    else
      @tags = Tag.where({:user_id => current_user[:id]}).order('name asc').load
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    # logger.debug "nowy tag: #{tag_params}"
    @tag = Tag.new(tag_params)

    if tag_params[:description] == ''
      tag_params[:description] = nil
    end

    if @tag.save
      redirect_to tags_url, notice: (I18n.t 'Tag was successfully created.')
    else
      render action: "new"
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    if tag_params[:description] == ''
      tag_params[:description] = nil
    end

    @tag = Tag.find(params[:id])

    if @tag.update_attributes(tag_params)
      redirect_to tags_path, notice: (I18n.t 'Tag was successfully updated.')
    else
      render action: "edit"
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])

    if @tag.count_expenses.size == 0
      @tag.destroy
      redirect_to tags_url, notice: (I18n.t 'Tag was successfully deleted.')
    else
      redirect_to tags_url
    end
  end
end
