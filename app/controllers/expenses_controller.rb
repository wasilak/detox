class ExpensesController < ApplicationController

  # include ActionView::Helpers::NumberHelper

  def expense_params
    params.require(:expense).permit(:amount, :date, :description, :userId, :half)
  end

  def tag_params
    params.require(:tag).permit(:name, :description, :user_id, :budget)
  end

  def expenses_tags_association_params
    params.require(:expenses_tags_association).permit(:expense_id, :tag_id)
  end

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.get_expenses(
      current_user[:id],
      session[:budget][:dateStart],
      session[:budget][:dateEnd],
      sort
    )

    @tags_form = Tag.where({:user_id => current_user[:id]}).order('name asc').all
    @tag_form_current = Expense.get_current_tags

    #clear selected tags
    Expense.set_tags []

    @budgets = Budget.get_all_user_budgets(current_user[:id])

    @expenses_sum = calculate_expenses_sum @expenses

    @used_tags = used_tags @expenses

    @chart_data = expenses_chart1 @used_tags
    @chart_data2 = expenses_chart2 @expenses
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @expense = Expense.find(params[:id])

    @tags = @expense.get_tags
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @expense = Expense.new

    # domyslnie dzisiejsza data
    time = Time.new
    @expense.date = "#{time.year}-#{time.month}-#{time.day}"
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])

    @expenseTags = @expense.get_tags

    @tags = Tag.where(:user_id => current_user[:id]).order('name asc').all
  end

  # POST /expenses
  # POST /expenses.json
  def create
    expense_params[:amount] = correct_value(expense_params[:amount])

    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to edit_expense_path(@expense), notice: (I18n.t 'Expense was successfully created.')
    else
      render action: "new"
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.json
  def update
    expense_params[:amount] = correct_value(expense_params[:amount])

    @expense = Expense.find(params[:id])

    @expenseTags = @expense.get_tags

    @tags = Tag.where(:user_id => current_user[:id]).includes(:user).order('name asc').all

    if @expense.update_attributes(expense_params)
      redirect_to expenses_path, notice: (I18n.t 'Expense was successfully updated.')
    else
      render action: "edit"
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy

    redirect_to expenses_url, notice: (I18n.t 'Expense was successfully deleted.')
  end

  def add_tag
    @expense = Expense.find(params[:id])

    @association = {
      :expense_id =>  params[:id],
      :tag_id =>  params[:tag],
    }

    @expense_tag_association = ExpensesTagsAssociation.new(@association)

    if @expense_tag_association.save
      redirect_to edit_expense_path(@expense), notice: (I18n.t 'Tag was successfully added.')
    else
      redirect_to edit_expense_path(@expense), notice: (I18n.t 'There was an error while adding tag.')
    end
  end

  def del_tag
    # @expense = Expense.find(expense_params[:id])

    @expense_tag_association = ExpensesTagsAssociation.find(params[:tag][:id])

    if @expense_tag_association.destroy
      redirect_to edit_expense_path(@expense_tag_association[:expense_id]), notice: (I18n.t 'Tag was successfully deleted.')
    else
      redirect_to edit_expense_path(@expense_tag_association[:expense_id]), notice: (I18n.t 'There was an error while adding tag.')
    end
  end

  def set_budget
    set_session_budget

    redirect_to expenses_url, notice: 'budget successfully changed.'
  end

  def set_tag_filter
    unless params[:tag].nil?
      Expense.set_tags params[:tag]
    end

    redirect_to expenses_url, notice: 'Filter successfully applied.'
  end

  private

  def expenses_chart1 (used_tags)
    chart_data = []
    used_tags.each do |tag, sum|
      chart_data.push([tag, sum])
    end
    chart_data
  end

  def expenses_chart2 expenses
    # expenses = Expense.get_expenses_budget(
    #   current_user[:id],
    #   session[:budget][:dateStart],
    #   session[:budget][:dateEnd]
    # )

    used_tags = {}
    expenses.each do |expense|
      expense.tags.each do |tag|
        if !tag.nil? and tag.budget
          if used_tags[tag.name].nil?
            used_tags[tag.name] = 0
          end

          if expense.half == 1
            used_tags[tag.name] += expense.amount / 2
          else
            used_tags[tag.name] += expense.amount
          end
        end
      end
    end

    chart_data = []
    used_tags.each do |tag, sum|
      chart_data.push([tag, sum])
    end
    chart_data
  end

  def used_tags expenses
    tags = {}
    expenses.each do |expense|
      expense.expenses_tags_association.each do |assoc|
        unless assoc.tag.nil?
          if tags[assoc.tag.name].nil?
            tags[assoc.tag.name] = 0
          end

          if expense.half == 1
            tags[assoc.tag.name] += expense.amount / 2
          else
            tags[assoc.tag.name] += expense.amount
          end
        end
      end
    end
    tags
  end

  def calculate_expenses_sum expenses
    sum = 0
    expenses.each do |expense|
      if expense.half == 1
        sum += expense.amount / 2
      else
        sum += expense.amount
      end
    end
    sum
  end

  def sort
    order = params[:sort]
    @direction = params[:direction]

    if @direction.nil?
      @direction = "desc"
    else
      @direction = (expense_params[:direction] == "asc") ? "desc" : "asc"
    end

    if order.nil?
      sort = "date desc"
    else
      sort = "#{order} #{@direction}"
    end

    @order_icon = (@direction == 'asc') ? "icon-chevron-up" : "icon-chevron-down"

    sort
  end

  def get_tags expenses
    tags = {}
    expenses.each do |expense|
      expense.expenses_tags_association.each do |assoc|
        unless assoc.tag.nil?
          if tags[assoc.tag.id].nil?
            tags[assoc.tag.id] = assoc.tag.name
          end
        end
      end
    end
    tags
  end

end
