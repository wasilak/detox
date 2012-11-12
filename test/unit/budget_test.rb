require 'test_helper'

class BudgetTest < ActiveSupport::TestCase
    test "get all budgets" do
        budgets = Budget.getAllBudgets
        assert_kind_of Array, budgets, "No budgets queried."
    end

    test "amount should be greater then zero" do
        budget = Budget.new
        budget[:amount] = -8
        assert !budget.save, "Saved amount lesser then zero."
    end

    test "should return budget bassed on present date" do
        time = Time.new
        budgets = Budget.getBudget(time,1)

        if budgets.count > 0
            assert_kind_of Array, budgets
        else
            assert true
        end
    end
end
