class Calculator
  def initialize
    @data = {}
  end

  def push(data)
    data.each_pair do |key, value|
      if value.kind_of?(Array)
        @data[key] ||= []
        @data[key] += value
      elsif value.kind_of?(Hash)
        @data[key] ||= {}
        @data[key].merge!(value)
      end
    end
  end

  def calculate!
    p check_first_rule
    p check_second_rule
    p check_third_rule
    p check_fourth_rule
  end

  private
  def check_first_rule
    total_classes_amount = @data[:classes].size
    small_classes_amount = @data[:classes].inject(0) do |sum, class_params|
      sum += 1 if class_params.last == true
      sum
    end
    missindented_classes_amount = @data[:missindented_classes].size

    [small_classes_amount, total_classes_amount, missindented_classes_amount]
  end

  def check_second_rule
    total_methods_amount = 0
    small_methods_amount = 0

    @data[:methods].each_pair do |klass, methods|
      small_methods_amount += methods.select { |m| m.last == true }.size
      total_methods_amount += methods.size
    end

    missindented_methods_amount = 0
    @data[:missindented_methods].each_pair do |klass, methods|
      missindented_methods_amount += methods.size
    end

    [small_methods_amount, total_methods_amount, missindented_methods_amount]
  end

  # TODO
  # count method definitions argumets too
  def check_third_rule
    total_method_calls = @data[:method_calls].size

    proper_method_calls = @data[:method_calls].inject(0) do |sum, params|
      sum += 1 unless params.first > 4
      sum
    end

    @data[:missindented_methods].each_pair do |klass, methods|
      missindented_classes_amount += methods.size
    end

    [proper_method_calls, total_method_calls]
  end

  def check_fourth_rule
    proper_controllers_amount = 0
    total_controllers_amount = 0

    @data[:instance_variables].each_pair do |controller, methods|
      total_controllers_amount += 1
      proper_controllers_amount += 1 unless methods.values.map(&:size).any? { |v| v > 1 }
    end

    [proper_controllers_amount, total_controllers_amount]
  end
end
