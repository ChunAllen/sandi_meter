module SandiMeter
  class Calculator
    def initialize
      @data = {}
      @output = {}
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

    def calculate!(store_details = false)
      @store_details = store_details

      check_first_rule
      check_second_rule
      check_third_rule
      check_fourth_rule

      @output
    end

    private
    def log_first_rule
      @output[:first_rule][:log] ||= {}
      @output[:first_rule][:log][:classes] = @data[:classes].inject([]) do |log, class_params|
        # TODO
        # wrap each class params into class and get params with
        # verbose name instead of array keys (class_params[2] should be klass.line_count)
        log << [class_params.first, class_params.last, class_params[2]] if class_params[-2] == false
        log
      end

      @output[:first_rule][:log][:missindented_classes] = @data[:missindented_classes].inject([]) do |log, class_params|
        log << [class_params.first, class_params.last]
        log
      end
    end

    def check_first_rule
      total_classes_amount = @data[:classes].size
      small_classes_amount = @data[:classes].inject(0) do |sum, class_params|
        sum += 1 if class_params[-2] == true
        sum
      end

      missindented_classes_amount = @data[:missindented_classes].size

      @output[:first_rule] ||= {}
      @output[:first_rule][:small_classes_amount] = small_classes_amount
      @output[:first_rule][:total_classes_amount] = total_classes_amount
      @output[:first_rule][:missindented_classes_amount] = missindented_classes_amount

      log_first_rule if @store_details
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

      @output[:second_rule] ||= {}
      @output[:second_rule][:small_methods_amount] = small_methods_amount
      @output[:second_rule][:total_methods_amount] = total_methods_amount
      @output[:second_rule][:missindented_methods_amount] = missindented_methods_amount
    end

    # TODO
    # count method definitions argumets too
    def check_third_rule
      total_method_calls = @data[:method_calls].size

      proper_method_calls = @data[:method_calls].inject(0) do |sum, params|
        sum += 1 unless params.first > 4
        sum
      end

      @output[:third_rule] ||= {}
      @output[:third_rule][:proper_method_calls] = proper_method_calls
      @output[:third_rule][:total_method_calls] = total_method_calls
    end

    def check_fourth_rule
      proper_controllers_amount = 0
      total_controllers_amount = 0

      @data[:instance_variables].each_pair do |controller, methods|
        total_controllers_amount += 1
        proper_controllers_amount += 1 unless methods.values.map(&:size).any? { |v| v > 1 }
      end

      @output[:fourth_rule] ||= {}
      @output[:fourth_rule][:proper_controllers_amount] = proper_controllers_amount
      @output[:fourth_rule][:total_controllers_amount] = total_controllers_amount
    end
  end
end
