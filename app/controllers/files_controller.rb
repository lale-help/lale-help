class FilesController < ApplicationController
  include HasCircle

  before_action :ensure_logged_in, except: :show

  skip_authorization_check

  def show
    file = FileUpload.find(params[:id])
    authorize! :read, file

    if stale? file
      expires_in(1.hour, public: false)
      filename = file.name + file.file_extension
      disposition = params.has_key?(:inline) ? 'inline' : 'attachment'
      send_data file.read, disposition: disposition, filename: filename, type: file.file_content_type
    end

  rescue => e
    Rails.logger.warning "#{e.message}: user: #{current_user.id} file: #{params[:id]}"
    render nothing: true, status: :not_found
  end

  def new
    @form = FileUpload::CreateForm.new(uploadable_gid: params[:uploadable], redirect_path: URI(request.referer || '').path)
    authorize! :manage, @form.uploadable
  end

  def create
    @form = FileUpload::CreateForm.new(params[:file_upload], uploader: current_user)
    authorize! :manage, @form.uploadable
    outcome = @form.submit
    if outcome.success?
      redirect_to @form.redirect_path, notice: t('flash.file_uploads.created')

    else
      render :new
    end
  end

  def edit
    file = FileUpload.find(params[:id])
    authorize! :manage, file
    @form = FileUpload::UpdateForm.new(file_upload: file, redirect_path: URI(request.referer || '').path)
  end

  def update
    file = FileUpload.find(params[:id])
    authorize! :manage, file
    @form = FileUpload::UpdateForm.new(params[:file_upload], file_upload: file)
    outcome = @form.submit
    if outcome.success?
      redirect_to @form.redirect_path, notice: t('flash.file_uploads.updated')

    else
      errors.add outcome.errors
      render :edit
    end
  end

  def destroy
    FileUpload::Destroy.run!( user: current_user, file: FileUpload.find(params[:id]) )
    redirect_to :back
  end
end