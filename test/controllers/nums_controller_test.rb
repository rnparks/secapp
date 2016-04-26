require 'test_helper'

class NumsControllerTest < ActionController::TestCase
  setup do
    @filer = filers(:one)
    @pre = @filer.pres(:one)
    @nums = @pre.nums
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nums)
  end

  test "should show num" do
    get :show, id: @num
    assert_response :success
  end

end
