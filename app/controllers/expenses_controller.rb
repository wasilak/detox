class ExpensesController < ApplicationController

  add_breadcrumb "expenses", :expenses_url

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.find(
      :all,
      :conditions =>  ['userId = ?',"#{session[:user][:id]}"],
      :order  =>  ['date desc'],
      :include => { :expenses_tags_association => :tag }
      )

    @used_tags = {}
    @expenses.each do |expense|
      expense.expenses_tags_association.each do |tag|
        if !tag.tag.nil?
          if @used_tags[tag.tag.name].nil?
            @used_tags[tag.tag.name] = 0
          end
          @used_tags[tag.tag.name] += expense.amount
        end
      end
    end

    @chart_data = []
    @used_tags.each do |tag, sum|
      @chart_data.push([tag, sum])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expenses }
    end
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @expense = Expense.find(params[:id])

    add_breadcrumb @expense.description, :expense_url

    @tags = @expense.getTags

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @expense = Expense.new

    add_breadcrumb 'new', ''

    # domyslnie dzisiejsza data
    time = Time.new
    @expense.date = "#{time.year}-#{time.month}-#{time.day}"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])

    add_breadcrumb @expense.description, :expense_url
    add_breadcrumb 'edit', ''

    @expenseTags = @expense.getTags
    @tags = Tag.find(
      :all,
      :conditions => ['user_id = ?', session[:user][:id]]
      )
  end

  # POST /expenses
  # POST /expenses.json
  def create
    params[:expense][:amount] = correct_value(params[:expense][:amount])

    @expense = Expense.new(params[:expense])

    respond_to do |format|
      if @expense.save
        format.html { redirect_to expenses_url, notice: 'Expense was successfully created.' }
        format.json { render json: @expense, status: :created, location: @expense }
      else
        format.html { render action: "new" }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.json
  def update
    params[:expense][:amount] = correct_value(params[:expense][:amount])

    @expense = Expense.find(params[:id])

    @expenseTags = @expense.getTags
    @tags = Tag.all

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy

    respond_to do |format|
      format.html { redirect_to expenses_url }
      format.json { head :no_content }
    end
  end

  def addTag
    @expense = Expense.find(params[:id])

    @association = {
      :expense_id =>  params[:id],
      :tag_id =>  params[:tag],
    }

    @expenseTagAssociation = ExpensesTagsAssociation.new(@association)

    respond_to do |format|
      if @expenseTagAssociation.save
        format.html { redirect_to edit_expense_path(@expense), notice: 'Tag was successfully added.' }
      else
        format.html { redirect_to edit_expense_path(@expense), notice: 'There was an error while adding tag.' }
      end
    end
  end

  def delTag
    # @expense = Expense.find(params[:id])

    @expenseTagAssociation = ExpensesTagsAssociation.find(params[:tag][:id])

    respond_to do |format|
      if @expenseTagAssociation.destroy
        format.html { redirect_to edit_expense_path(@expenseTagAssociation[:expense_id]),
          notice: 'Tag was successfully deleted.' }
      else
        format.html { redirect_to edit_expense_path(@expenseTagAssociation[:expense_id]),
          notice: 'There was an error while adding tag.' }
      end
    end
  end
end
