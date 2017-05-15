class EditionsBatchesController < ApplicationController
  def update
    editions = Edition.where(id: params.fetch(:edition_ids))
    update_editions_count = editions.update_all(editions_params.to_h)
    render json: update_editions_count
  end

  private

  def editions_params
    params.require(:editions_batch).permit(:read)
  end
end
