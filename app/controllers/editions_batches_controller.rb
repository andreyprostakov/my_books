class EditionsBatchesController < ApplicationController
  def update
    editions = Edition.where(id: params.fetch(:edition_ids))
    update_editions_count = EditionsBatchFormHandler.new(params).update_editions(editions)
    render json: update_editions_count
  end
end
