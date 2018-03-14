module Preferred::Preferable

  def preference(name, type, *args)
    options = args.extract_options!
    options.assert_valid_keys(:default, :description)
    default = options[:default]
    description = options[:description] || name

    # cache_key will be nil for new objects, then if we check if there
    # is a pending preference before going to default
    define_method preference_getter_method(name) do
      if self.preference_hash && preference_hash.key?(name.to_s)
        convert_preference_value(preference_hash[name.to_s]["value"], preference_hash[name.to_s]["type"])
      else
        send self.class.preference_default_getter_method(name)
      end
    end

    define_method preference_setter_method(name) do |value|
      value = convert_preference_value(value, type)
      self.preference_hash = {} if preference_hash.nil?
      self.preference_hash[name.to_s] = {
        value: value,
        type: type
      }
    end

    define_method preference_default_getter_method(name) do
      default
    end

    define_method preference_type_getter_method(name) do
      type
    end

    define_method preference_description_getter_method(name) do
      description
    end
  end

  def remove_preference(name)
    remove_method preference_getter_method(name) if method_defined? preference_getter_method(name)
    remove_method preference_setter_method(name) if method_defined? preference_setter_method(name)
    remove_method preference_default_getter_method(name) if method_defined? preference_default_getter_method(name)
    remove_method preference_type_getter_method(name) if method_defined? preference_type_getter_method(name)
    remove_method preference_description_getter_method(name) if method_defined? preference_description_getter_method(name)
  end

  def preference_getter_method(name)
    "preferred_#{name}".to_sym
  end

  def preference_setter_method(name)
     "preferred_#{name}=".to_sym
  end

  def preference_default_getter_method(name)
    "preferred_#{name}_default".to_sym
  end

  def preference_type_getter_method(name)
    "preferred_#{name}_type".to_sym
  end

  def preference_description_getter_method(name)
    "preferred_#{name}_description".to_sym
  end

end
