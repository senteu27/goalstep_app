class GoalsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  def index
    @user = User.all
  end

  def new
      @goal = Goal.new
      @goal.min_goals.build
  end
  def create
    @goal = current_user.goals.new(goal_params)


  if @goal.save
    redirect_to goals_path
  else
    render :new
  end
end

  private

  def goal_params
    params.require(:goal).permit(:name, :deadline,
    min_goals_attributes: [:name, :deadline,:check,:importance])
    
  end

end
