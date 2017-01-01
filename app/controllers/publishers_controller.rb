class PublishersController < ApplicationController
  before_action :fetch_publisher, only: %i(show edit update destroy)

  def index
    @publishers = Publisher.by_names
  end

  def show
  end

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(publisher_params)
    if @publisher.save
      redirect_to publishers_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @publisher.update_attributes(publisher_params)
      redirect_to publishers_path
    else
      render :edit
    end
  end

  def destroy
    @publisher.destroy
    redirect_to publishers_path
  end

  private

  def fetch_publisher
    @publisher = Publisher.find(params[:id])
  end

  def publisher_params
    params.require(:publisher).permit(:name)
  end
end
