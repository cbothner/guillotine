require 'test_helper'

class DonationListCellTest < Cell::TestCase
  test "show" do
    invoke :show
    assert_select "p"
  end
  

end
