require 'test_helper'

class CandidateRevisionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:candidate_revisions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create candidate_revision" do
    assert_difference('CandidateRevision.count') do
      post :create, :candidate_revision => { }
    end

    assert_redirected_to candidate_revision_path(assigns(:candidate_revision))
  end

  test "should show candidate_revision" do
    get :show, :id => candidate_revisions(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => candidate_revisions(:one).id
    assert_response :success
  end

  test "should update candidate_revision" do
    put :update, :id => candidate_revisions(:one).id, :candidate_revision => { }
    assert_redirected_to candidate_revision_path(assigns(:candidate_revision))
  end

  test "should destroy candidate_revision" do
    assert_difference('CandidateRevision.count', -1) do
      delete :destroy, :id => candidate_revisions(:one).id
    end

    assert_redirected_to candidate_revisions_path
  end
end
