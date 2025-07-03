class ActivitiesController < ApplicationController
  def history
    @activities = UserActivity.recent_activities(10) # 過去10日分を表示
    @achievements = Achievement.where(completed: true).where('date >= ?', 10.days.ago.to_date).order(date: :desc, updated_at: :desc)
    @page_title = "最近の活動履歴"
    @page_subtitle = "過去10日間の詳細記録"
  end

  def monthly
    @monthly_stats = Achievement.monthly_stats
    @page_title = "1ヶ月の活動記録"
    @page_subtitle = "過去30日間の継続状況"
  end

  def daily
    @date = Date.parse(params[:date])
    @activities = UserActivity.where(date: @date).order(:created_at)
    @achievements = Achievement.where(date: @date, completed: true).order(:updated_at)
    @page_title = "#{@date.strftime("%m月%d日")}の活動"
    @page_subtitle = "#{%w[日 月 火 水 木 金 土][@date.wday]}曜日の詳細"
  end
end
