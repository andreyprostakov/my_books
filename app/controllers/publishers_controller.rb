class PublishersController < ApplicationController
  before_action :fetch_publisher, only: %i(edit update destroy)

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      respond_to do |format|
        format.json { render json: @publisher }
        format.html { redirect_to root_path(publisher: @publisher.name) }
      end
    else
      respond_to do |format|
        format.json { render json: @publisher.errors, status: 422 }
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if @publisher.update_attributes(publisher_params)
      respond_to do |format|
        format.json { render json: @publisher }
        format.html { redirect_to root_path(publisher: @publisher.name) }
      end
    else
      respond_to do |format|
        format.json { render json: @publisher.errors, status: 422 }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @publisher.destroy
    respond_to do |format|
      format.json { render json: {} }
      format.html { redirect_to root_path }
    end
  end

  private

  def fetch_publisher
    @publisher = Publisher.find(params[:id])
  end

  def publisher_params
    params.require(:publisher).permit(:name)
  end
end
