def initialize(*args)
    super
    @action = :create
end

actions :create

attribute :ruby_string, :required => true, :name_attribute => true, :kind_of => String
attribute :set_default, :default => false
attribute :gemset, :kind_of => String
