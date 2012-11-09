require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
    test "get all budgets" do
        @budgets = Budget.getAllBudgets
        assert_kind_of Array, @budgets
    end

    test "should not save without amount" do
        budget = Budget.new
        assert !budget.save, "Should not save without amount."
    end

    test "amount should be greater then zero" do
        budget = Budget.new
        budget[:amount] = -8
        assert !budget.save, "Amount should be greater then zero."
    end
end
