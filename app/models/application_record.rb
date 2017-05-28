class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def reset_counters(*counters)
    self.class.reset_counters(id, *counters)
  end
end
