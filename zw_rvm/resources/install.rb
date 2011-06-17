def initialize(*args)
    super
    @action = :create
end

actions :create

attribute :ruby_string, :name_attribute => true
