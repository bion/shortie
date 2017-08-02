class ServiceBase
  include Wisper::Publisher

  def self.run(*args)
    new(*args).run
  end

  def self.register_and_run(*args, &block)
    service = new(*args)

    yield service

    service.run
  end
end
