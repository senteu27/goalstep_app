class GoalsController < ApplicationController
  def index
    @user = User.all
  end
end
