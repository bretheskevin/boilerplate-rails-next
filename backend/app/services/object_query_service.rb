class ObjectQueryService
  def self.apply(object, params)
    scopes = [:with_deleted, :only_deleted]

    scopes.each do |scope|
      object = object.send(scope) if params[scope] == "1" && object.respond_to?(scope)
    end

    object
  end
end
