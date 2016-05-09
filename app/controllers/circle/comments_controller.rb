class Circle::CommentsController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in
  before_action :set_comment, :only => [:destroy, :update]

  include HasCircle

  def index
    authorize! :read, current_item
    if can? :create, Comment, current_item
      @form = Comment::Create.new(commenter: current_user, item: current_item, comment: Comment.new)
    end
    render layout: false
  end

  def create
    authorize! :create, Comment, current_item

    @comment = Comment.new
    @form = Comment::Create.new(params[:comment], commenter: current_user, item: current_item, comment: @comment)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_commentable_path(current_circle, current_item),
      notice: t('flash.created', name: Comment.model_name.human)
    else
      redirect_to circle_commentable_path(current_circle, current_item),
      alert: t('flash.failed.create', name: Comment.model_name.human)
    end
  end

  def destroy
    # TODO: Implement comment destroy method

  end

  helper_method def current_item
    @item ||= if params[:supply_id].present?
                Supply.find(params[:supply_id])
              elsif params[:member_id].present?
                User.find(params[:member_id])
              else
                Task.find(params[:task_id])
              end
  end

  helper_method def page
    @page ||= OpenStruct.new.tap do |page|
    end
  end

  private

    def set_comment
      @comment = current_item.comments.find(params[:id])
    end

    def circle_commentable_path(circle, item)
      if item.is_a? Supply
        circle_supply_path(circle, item)
      elsif item.is_a? User
        circle_member_path(circle, item)
      else
        circle_task_path(circle, item)
      end
    end
end
