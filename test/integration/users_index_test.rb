require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  test "users index should have pagination and display links to users" do
    log_in_as(users(:testuser))
    get users_path
    assert_response :success
    assert_select "div.pagination"
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

end
