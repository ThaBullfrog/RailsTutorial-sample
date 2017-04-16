require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:testuser)
    @admin = users(:testadmin)
  end

  test "users index should have pagination and display links to users" do
    log_in_as(@user)
    get users_path
    assert_response :success
    assert_select "div.pagination"
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "users index shouldn't have manage users link for non-admins" do
    log_in_as(@user)
    get users_path
    assert_select "a.admin-link", count: 0
  end

  test "users index should have a manage users link for admins" do
    log_in_as(@admin)
    get users_path
    assert_select "a.admin-link"
  end

  test "clicking the manage users link on the users index shouldn't send back to page one" do
    log_in_as @admin
    get users_path(page: 2)
    assert_select "a.admin-link:match('href', ?)", /page=2/i
    get users_path(page: 2, manage: true)
    assert_select "a.admin-link:match('href', ?)", /page=2/i
  end

end
