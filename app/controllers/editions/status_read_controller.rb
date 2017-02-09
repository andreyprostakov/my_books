module Editions
  class StatusReadController < ApplicationController
    before_action :fetch_edition

    def create
      @edition.update_attribute(:read, true)
      redirect_to :back
    end

    def destroy
      @edition.update_attribute(:read, false)
      redirect_to :back
    end

    private

    def fetch_edition
      @edition = Edition.find(params[:edition_id])
    end
  end
end
