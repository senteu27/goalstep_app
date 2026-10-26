class GoalsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show]
  before_action :check_user_goal, only: [:show, :edit, :update, :destroy]
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
    redirect_to goal_path(@goal)
  else
    render :new, status: :unprocessable_content
  end
end

def show
  @min_goals = MinGoal.all
end

def edit
end

def update

  if @goal.update(goal_params)
    redirect_to goal_path(@goal)
  else
    render :edit, status: :unprocessable_content
  end
end

def destroy
  @goal.destroy
  redirect_to root_path
end

  private

  def goal_params
    params.require(:goal).permit(:name, :deadline,
    min_goals_attributes: [:name, :deadline,:check,:importance, :id])
  end

  def check_user_goal
    @goal = current_user.goals.find(params[:id])
  end

end
