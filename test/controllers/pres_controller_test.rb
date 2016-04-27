require 'test_helper'
    assert_not_nil assigns(:nums)


class PresControllerTest < ActionController::TestCase
  setup do
  	@filer = filers(:one)
    @pre = @filer.pres(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should show num" do
    get :show, id: @pre
    assert_response :success
  end
end
