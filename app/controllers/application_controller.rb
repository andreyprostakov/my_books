class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    @var = 13
  end
end
