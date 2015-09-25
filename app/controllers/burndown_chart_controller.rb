class BurndownChartController < ApplicationController
  layout "circle_page"
  before_action :preprocess

  def index
  end

  private
  def preprocess
    @volunteer = Volunteer.find(params[:volunteer_id])

    tasks = @volunteer.tasks

    completion_dates = tasks.reject { |t| t.completed_at.nil? }.map { |t| t.completed_at }

    dateList = if (completion_dates.empty?)
                 []
               else
                 startDate = completion_dates.min.to_date - 1
                 endDate = completion_dates.max.to_date + 1
                 (startDate .. endDate).to_a
               end

    burnUpCounts = dateList.map { |d| completion_dates.count { |cd| cd <= d } }

    @data = dateList.zip(burnUpCounts)
  end
end
