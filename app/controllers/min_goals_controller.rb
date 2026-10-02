class MinGoalsController < ApplicationController
  before_action :authenticate_user!

  def update
    @min_goal = MinGoal.joins(:goal)
                       .where(goals: { user_id: current_user.id })
                       .find(params[:id])
                       @min_goal.skip_deadline_validation = true

    @min_goal.update!(check: params.require(:min_goal).permit(:check)[:check])

    head :ok
end
end
