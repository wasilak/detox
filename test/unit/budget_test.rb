require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
    test "get all budgets" do
        @budgets = Budget.getAllBudgets
        assert_kind_of Array, @budgets, "No budgets queried."
    end

    test "amount should be greater then zero" do
        budget = Budget.new
        budget[:amount] = -8
        assert !budget.save, "Saved amount lesser then zero."
    end
end
