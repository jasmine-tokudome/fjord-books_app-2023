# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      extract_urls = params[:report][:content].scan(/http:\/\/localhost\:3000\/reports\/(\d+)/).uniq.flatten
      if extract_urls.any?
        extract_urls.each do |extract_url|
          Mention.create(mentioning_report_id: @report.id, mentioned_report_id: extract_url)
        end
      end
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      matching_mentions = Mention.where(mentioning_report_id: @report.id)
      Mention.destroy(matching_mentions.ids)
      extract_urls = params[:report][:content].scan(/http:\/\/localhost\:3000\/reports\/(\d+)/).uniq.flatten
      if extract_urls.any?
        extract_urls.each do |extract_url|
          Mention.create(mentioning_report_id: @report.id, mentioned_report_id: extract_url)
        end
      end
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    report_id = @report.id
    Mention.find_by(mentioned_report_id: report_id).destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
