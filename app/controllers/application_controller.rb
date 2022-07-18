class ApplicationController < ActionController::Base

  def sayHello
    render html: "Hello, Heroku!"
  end
end
