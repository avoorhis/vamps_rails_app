require 'spec_helper'

describe "Visualisation" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login_as(@user, :scope => :user)
  end

  it "shows heatmap"

end