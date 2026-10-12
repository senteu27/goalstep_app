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
    redirect_to goal_path(@goal)
  else
    render :new
  end
end

def show
  @goal = current_user.goals.find(params[:id])
  @min_goals = MinGoal.all
end

def edit
  @goal = current_user.goals.find(params[:id])
end

def update
  @goal = current_user.goals.find(params[:id])

  if @goal.update(goal_params)
    redirect_to goal_path(@goal)
  else
    render :edit
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
  end

end
