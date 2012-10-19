class EquationToTable
  attr_accessor :equations
  def initialize(equations, opts = {})
    self.equations = equations.map{|x| x.split("=").map(&:strip)}
    @inputs = opts[:order].split('') if opts[:order]
  end

  def inputs
    @inputs ||= begin
      equations.map do |_,eq|
        eq.gsub(/[^a-zA-Z]/, '').split('')
      end
    end.flatten.uniq.sort
  end

  def num_inputs
    @num_inputs ||= inputs.length
  end

  def outputs
    @outputs ||= begin
      equations.map(&:first).uniq.sort 
    end
  end

  def num_outputs
    @num_outputs ||= outputs.length
  end

  def to_table
    terms = equations.map do |eq|
      evaluate_equation(eq.last)
    end

    table = ["%s %s" % [inputs * '', outputs * '']]
    terms = terms.transpose.map(&:join)

    0.upto(2 ** num_inputs - 1).map do |index|
      table << ("%0#{num_inputs}d %s" % [index.to_s(2).to_i, terms[index]])
    end
    table
  end

  def evaluate_equation(eq)
    0.upto(2 ** num_inputs - 1).map do |index|
      assign(index)
      eval(eq.gsub(/([a-zAZ])/, '@\1')).to_s
    end
  end

  # %w(a b c d ...)
  def assign(term)
    num_inputs.times do 
      instance_variable_set("@#{inputs.last}", term & 1)
      inputs.rotate!(-1)
      term >>= 1
    end
  end

end
