class TagsController < ApplicationController

  # GET /tags
  # GET /tags.json
  def index
    if current_user[:type_id] == 2
      @tags = Tag.includes(:user).all
    else
      @tags = Tag.where({:user_id => current_user[:id]}).all
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
    # logger.debug "nowy tag: #{params[:tag]}"
    @tag = Tag.new(params[:tag])

    if params[:tag][:description] == ''
      params[:tag][:description] = nil
    end

    if @tag.save
      redirect_to tags_url, notice: 'Tag was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    if params[:tag][:description] == ''
      params[:tag][:description] = nil
    end

    @tag = Tag.find(params[:id])

    if @tag.update_attributes(params[:tag])
      redirect_to tags_path, notice: 'Tag was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])

    if @tag.count_expenses == 0
      @tag.destroy
    end

    redirect_to tags_url
  end
end
