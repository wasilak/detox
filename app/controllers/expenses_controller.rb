class ExpensesController < ApplicationController

  # include ActionView::Helpers::NumberHelper

  add_breadcrumb "expenses", :expenses_url

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.get_expenses(
      current_user[:id],
      session[:budget][:dateStart],
      session[:budget][:dateEnd],
      sort
    )

    @budgets = Budget.get_all_user_budgets(current_user[:id])

    @budgets_sum = 0

    @used_tags = {}
    @expenses.each do |expense|
      @budgets_sum += expense.amount
      expense.expenses_tags_association.each do |tag|
        unless tag.tag.nil?
          if @used_tags[tag.tag.name].nil?
            @used_tags[tag.tag.name] = 0
          end
          @used_tags[tag.tag.name] += expense.amount
        end
      end
    end

    @chart_data = expenses_chart1 @used_tags
    @chart_data2 = expenses_chart2

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

    @tags = @expense.get_tags

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

    @expenseTags = @expense.get_tags

    @tags = Tag.where(:user_id => current_user[:id]).all
  end

  # POST /expenses
  # POST /expenses.json
  def create
    params[:expense][:amount] = correct_value(params[:expense][:amount])

    @expense = Expense.new(params[:expense])

    respond_to do |format|
      if @expense.save
        format.html { redirect_to edit_expense_path(@expense), notice: 'Expense was successfully created.' }
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

    @expenseTags = @expense.get_tags

    @tags = Tag.where(:user_id => current_user[:id]).includes(:user).all

    respond_to do |format|
      if @expense.update_attributes(params[:expense])
        format.html { redirect_to expenses_path, notice: 'Expense was successfully updated.' }
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

  def add_tag
    @expense = Expense.find(params[:id])

    @association = {
      :expense_id =>  params[:id],
      :tag_id =>  params[:tag],
    }

    @expense_tag_association = ExpensesTagsAssociation.new(@association)

    respond_to do |format|
      if @expense_tag_association.save
        format.html { redirect_to edit_expense_path(@expense), notice: 'Tag was successfully added.' }
      else
        format.html { redirect_to edit_expense_path(@expense), notice: 'There was an error while adding tag.' }
      end
    end
  end

  def del_tag
    # @expense = Expense.find(params[:id])

    @expense_tag_association = ExpensesTagsAssociation.find(params[:tag][:id])

    respond_to do |format|
      if @expense_tag_association.destroy
        format.html { redirect_to edit_expense_path(@expense_tag_association[:expense_id]),
          notice: 'Tag was successfully deleted.' }
      else
        format.html { redirect_to edit_expense_path(@expense_tag_association[:expense_id]),
          notice: 'There was an error while adding tag.' }
      end
    end
  end

  def set_budget
    set_session_budget

    respond_to do |format|
        format.html { redirect_to expenses_url, notice: 'budget successfully changed.' }
        format.json { render json: @expense, status: :created, location: @expense }
    end
  end

  private

  def expenses_chart1 (used_tags)
    chart_data = []
    used_tags.each do |tag, sum|
      chart_data.push([tag, sum])
    end
    chart_data
  end

  def expenses_chart2
    expenses = Expense.get_expenses_budget(
      current_user[:id],
      session[:budget][:dateStart],
      session[:budget][:dateEnd]
    )

    used_tags = {}
    expenses.each do |expense|
      expense.tags.each { |tag|
        unless tag.nil?
          if used_tags[tag.name].nil?
            used_tags[tag.name] = 0
          end
          used_tags[tag.name] += expense.amount
        end }
    end

    chart_data = []
    used_tags.each do |tag, sum|
      chart_data.push([tag, sum])
    end
    chart_data
  end

  def sort
    order = params[:sort]
    @direction = params[:direction]

    if @direction.nil?
      @direction = "desc"
    else
      @direction = (params[:direction] == "asc") ? "desc" : "asc"
    end

    if order.nil?
      sort = "date desc"
    else
      sort = "#{order} #{@direction}"
    end

    @order_icon = (@direction == 'asc') ? "icon-chevron-up" : "icon-chevron-down"

    sort
  end

end
