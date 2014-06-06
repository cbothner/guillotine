require 'test_helper'

class RewardListCellTest < Cell::TestCase
  test "show" do
    invoke :show
    assert_select "p"
  end
  

end
