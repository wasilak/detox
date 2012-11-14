class TagsController < ApplicationController

  add_breadcrumb "tags", :tags_url

  # GET /tags
  # GET /tags.json
  def index
    if session[:user][:type_id] == 2
      @tags = Tag.find(
        :all,
        :include => [:expenses_tags_association, :user]
        )
    else
      @tags = Tag.find(
        :all,
        :conditions => ['user_id = ?', session[:user][:id]],
        :include => [:expenses_tags_association, :user]
        )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])

    add_breadcrumb @tag.name, :tag_url

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new

    add_breadcrumb 'new', ''

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])

    add_breadcrumb 'edit', ''
  end

  # POST /tags
  # POST /tags.json
  def create
    # logger.debug "nowy tag: #{params[:tag]}"
    @tag = Tag.new(params[:tag])

    if params[:tag][:description] == ''
      params[:tag][:description] = nil
    end

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_url, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    if params[:tag][:description] == ''
      params[:tag][:description] = nil
    end

    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to tags_path, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])

    if @tag.countExpenses == 0
      @tag.destroy
    end

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
