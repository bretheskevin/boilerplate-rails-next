module KB
  class CrudRouteConcern
    def initialize(defaults = {})
      @defaults = defaults
    end

    # rubocop:disable all
    def call(mapper, options = {})
      _options = @defaults.merge(options)

      mapper.member do
        # mapper.post :default
      end
      mapper.collection do
        # mapper.get :tags
      end
    end
  end
end
