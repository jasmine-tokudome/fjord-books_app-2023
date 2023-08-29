# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, alert: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.common.needs_input', name: Comment.model_name.human)
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to @commentable, alert: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.common.user_only', name: Comment.model_name.human)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:name, :comment)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
