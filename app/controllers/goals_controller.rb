class GoalsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show]
  def index
    @user = User.all
    
    if user_signed_in?
    @goals = current_user.goals
    end
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

def show
  @goal = current_user.goals.find(params[:id])
  @min_goals = MinGoal.all
end

  private

  def goal_params
    params.require(:goal).permit(:name, :deadline,
    min_goals_attributes: [:name, :deadline,:check,:importance])
    
  end

end
