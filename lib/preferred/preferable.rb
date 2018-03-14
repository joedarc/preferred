module Preferred::Preferable
  extend ActiveSupport::Concern

  included do
    extend PreferableClassMethods
  end

  def get_preference(name)
    has_preference! name
    send self.class.preference_getter_method(name)
  end
  alias :preferred :get_preference
  alias :prefers? :get_preference

  def set_preference(name, value)
    has_preference! name
    send self.class.preference_setter_method(name), value
  end

  def preference_type(name)
    has_preference! name
    send self.class.preference_type_getter_method(name)
  end

  def preference_default(name)
    has_preference! name
    send self.class.preference_default_getter_method(name)
  end

  def preference_description(name)
    has_preference! name
    send self.class.preference_description_getter_method(name)
  end

  def has_preference!(name)
    raise NoMethodError.new "#{name} preference not defined" unless has_preference? name
  end

  def has_preference?(name)
    respond_to? self.class.preference_getter_method(name)
  end

  def preferences
    prefs = {}
    methods.grep(/^prefers_.*\?$/).each do |pref_method|
      prefs[pref_method.to_s.gsub(/prefers_|\?/, '').to_sym] = send(pref_method)
    end
    prefs
  end

  def clear_preferences
    preference_hash.keys.each {|pref| preference_hash.delete pref} if preference_hash.is_a? Hash
  end

  private

  def convert_preference_value(value, type)
    case type
    when :string, :text
      value.to_s
    when :password
      value.to_s
    when :decimal
      BigDecimal.new(value.to_s)
    when :integer
      value.to_i
    when :boolean
      if value.is_a?(FalseClass) ||
        value.nil? ||
        value == 0 ||
        value =~ /^(f|false|0)$/i ||
        (value.respond_to? :empty? and value.empty?)
        false
      else
        true
      end
    when :date
      value.is_a?(Date) ? value : Date.parse(value)
    else
      value
    end
  end

end
