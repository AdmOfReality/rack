require_relative 'time_app'

class App
  def call(env)
    TimeApp.new.call(env)
  end
end

