class EditionsBatchesController < ApplicationController
  def update
    editions = Edition.where(id: params.fetch(:edition_ids))
    if form_handler.update_editions(editions)
      render json: editions
    else
      render json: form_handler.edition_with_errors.errors, status: 422
    end
  end

  private

  def form_handler
    @form_handler ||= EditionsBatchFormHandler.new(params)
  end
end
