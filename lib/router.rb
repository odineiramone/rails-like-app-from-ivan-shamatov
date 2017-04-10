class Router
  attr_reader :routes

  def initialize(routes)
    @routes = routes
  end

  def resolve(env)
    path = env['REQUEST_PATH']
    routes.key? path ? ctrl(routes[path]) : Controller.new.not_found
  rescue Exception => error
    puts error.message
    puts error.backtrace
    Controller.new.internal_error
  end

  private

  def ctrl(string)
    ctrl_name, action_name = string.split '#'
    klass = Object.const_get "#{ctrl_name.captalize}Controller"
    klass.new(name: ctrl_name, action: action_name.to_sym)
  end
end
