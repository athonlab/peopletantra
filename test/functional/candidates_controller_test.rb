require 'test_helper'

class CandidatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:candidates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create candidate" do
    assert_difference('Candidate.count') do
      post :create, :candidate => { }
    end

    assert_redirected_to candidate_path(assigns(:candidate))
  end

  test "should show candidate" do
    get :show, :id => candidates(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => candidates(:one).id
    assert_response :success
  end

  test "should update candidate" do
    put :update, :id => candidates(:one).id, :candidate => { }
    assert_redirected_to candidate_path(assigns(:candidate))
  end

  test "should destroy candidate" do
    assert_difference('Candidate.count', -1) do
      delete :destroy, :id => candidates(:one).id
    end

    assert_redirected_to candidates_path
  end
end
