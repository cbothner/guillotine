require 'test_helper'

class PledgersControllerTest < ActionController::TestCase
  setup do
    @pledger = pledgers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pledgers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pledger" do
    assert_difference('Pledger.count') do
      post :create, pledger: { affiliation: @pledger.affiliation, email: @pledger.email, first_name: @pledger.first_name, individual: @pledger.individual, last_name: @pledger.last_name, local_address2: @pledger.local_address2, local_address: @pledger.local_address, local_city: @pledger.local_city, local_phone: @pledger.local_phone, local_state: @pledger.local_state, local_zip: @pledger.local_zip, perm_address2: @pledger.perm_address2, perm_address: @pledger.perm_address, perm_city: @pledger.perm_city, perm_country: @pledger.perm_country, perm_phone: @pledger.perm_phone, perm_state: @pledger.perm_state, perm_zip: @pledger.perm_zip }
    end

    assert_redirected_to pledger_path(assigns(:pledger))
  end

  test "should show pledger" do
    get :show, id: @pledger
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pledger
    assert_response :success
  end

  test "should update pledger" do
    put :update, id: @pledger, pledger: { affiliation: @pledger.affiliation, email: @pledger.email, first_name: @pledger.first_name, individual: @pledger.individual, last_name: @pledger.last_name, local_address2: @pledger.local_address2, local_address: @pledger.local_address, local_city: @pledger.local_city, local_phone: @pledger.local_phone, local_state: @pledger.local_state, local_zip: @pledger.local_zip, perm_address2: @pledger.perm_address2, perm_address: @pledger.perm_address, perm_city: @pledger.perm_city, perm_country: @pledger.perm_country, perm_phone: @pledger.perm_phone, perm_state: @pledger.perm_state, perm_zip: @pledger.perm_zip }
    assert_redirected_to pledger_path(assigns(:pledger))
  end

  test "should destroy pledger" do
    assert_difference('Pledger.count', -1) do
      delete :destroy, id: @pledger
    end

    assert_redirected_to pledgers_path
  end
end
