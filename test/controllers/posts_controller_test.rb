require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @post_one = posts(:one)
    @post_two = posts(:two)
    @user_one = users(:one)
  end

  test 'guest should see index' do
    get posts_path
    assert_response :success
  end

  test 'guest should see post detail' do
    get post_path(@post_one)
    assert_response :success
  end

  test 'guest should not see new post' do
    get new_post_path
    assert_redirected_to new_user_session_path
  end

  test 'user should create post' do
    sign_in @user_one
    assert_difference("Post.count") do
      post posts_path, params: { post: { title: 'Mi post!', content: 'cualquier cosa' } }
    end
    assert_redirected_to post_path(@user_one.posts.last)
  end

  test "user should edit his own post" do
    sign_in @user_one
    get edit_post_path(@post_one)
    assert_response :success
  end

  test "user should not edit post from other user" do
    sign_in @user_one
    get edit_post_path(@post_two)
    assert_redirected_to posts_path
  end
  
  test "user should destroy his own post" do
    sign_in @user_one
    assert_difference("Post.count", -1) do
      delete post_path(@post_one)
    end
  end

  test "user should not destroy post from other user" do
    sign_in @user_one
    assert_no_difference("Post.count") do
      delete post_path(@post_two)
    end
    assert_redirected_to posts_path
  end

  # test "should get index" do
  #   get posts_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_post_url
  #   assert_response :success
  # end

  # test "should create post" do
  #   assert_difference('Post.count') do
  #     post posts_url, params: { post: { content: @post.content, title: @post.title, user_id: @post.user_id } }
  #   end

  #   assert_redirected_to post_url(Post.last)
  # end

  # test "should show post" do
  #   get post_url(@post)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_post_url(@post)
  #   assert_response :success
  # end

  # test "should update post" do
  #   patch post_url(@post), params: { post: { content: @post.content, title: @post.title, user_id: @post.user_id } }
  #   assert_redirected_to post_url(@post)
  # end

  # test "should destroy post" do
  #   assert_difference('Post.count', -1) do
  #     delete post_url(@post)
  #   end

  #   assert_redirected_to posts_url
  # end
end
