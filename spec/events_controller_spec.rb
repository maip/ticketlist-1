require "rails_helper"
require 'controller_macros'

describe "User Profiles" do
  login_user

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end
end