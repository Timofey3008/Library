require 'test_helper'

class UserTest < ActiveSupport::TestCase
   test "Empty Registation of user" do
     user = User.new
     assert_not user.save
   end
end
