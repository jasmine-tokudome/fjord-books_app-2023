# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  # def create
  #   @comment = @commentable.comments.build(comment_params)
  #   @comment.user = current_user
  #   if @comment.save
  #     redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  #   else
  #     # @comments = @commentable.comments
  #     # render_commentable_show
  #   end
  # end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, notice: t('controllers.common.needs_input', name: Comment.model_name.human)
    end
    end

  def destroy
    comment.destroy
    redirect_to commentable, status: :see_other
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end
end
