require "rspec/mocks/standalone"
require_relative "../equation_to_table"

describe EquationToTable do

  describe "#new" do
    it "builds set of equations" do
      described_class.new(["a = a & b"]).equations.should ==  [["a", "a & b"]]
      described_class.new(["a = a & b", "c = x ^ d"]).equations.should ==  [
        ["a", "a & b"], 
        ["c", "x ^ d"]
      ]
    end
  end

  describe "#inputs" do
    it "figures out the input variables from one equation"  do
      eq = described_class.new(["a = a & b"]) 
      eq.inputs.should == %w(a b)
    end

    it "figures out the input variables from two equations"  do
      eq = described_class.new(["a = a & b", "d = a & cd"]) 
      eq.inputs.should == %w(a b c d)
    end

    it "sorts input variables from two equations"  do
      eq = described_class.new(["a = da & b", "d = a & c"]) 
      eq.inputs.should == %w(a b c d)
    end
  end

  describe "assign" do
    it "assigns instance variables with corresponding bit values of term" do
      eq = described_class.new(["a= a & b"])
      eq.assign(0b01)
      eq.instance_variable_get("@a").should == 0
      eq.instance_variable_get("@b").should == 1
    end

    it "assigns instance variables with according to provided order" do
      eq = described_class.new(["a= a & b"], :order => 'ba')
      eq.assign(0b01)
      eq.instance_variable_get("@a").should == 1
      eq.instance_variable_get("@b").should == 0
    end

    it "assigns instance variables with according to provided order" do
      eq = described_class.new(["a= a ^ b | c"], :order => 'bac')
      eq.assign(0b011)
      eq.instance_variable_get("@a").should == 1
      eq.instance_variable_get("@b").should == 0
      eq.instance_variable_get("@c").should == 1
    end
  end
  describe "#outputs" do
    it "figures out the output variable of one equation"  do
      eq = described_class.new(["a = a & b"]) 
      eq.outputs.should == %w(a)
    end

    it "figures out the output variables from two equations"  do
      eq = described_class.new(["a = a & b", "d = a & cd"]) 
      eq.outputs.should == %w(a d)
    end
  end

  describe "#evaluate_equation" do
    it "evaluates all terms for equation" do
      eq = described_class.new(["a = a & b"])
      eq.evaluate_equation("a & b").should ==  ["0", "0", "0", "1"]

      eq = described_class.new(["a = a ^ b"])
      eq.evaluate_equation("a ^ b").should ==  ["0", "1", "1", "0"]
    end
  end

  describe "#to_table" do
    it "generates the truth table for one function" do
      eq = described_class.new(["a = a & b"])
      eq.to_table.should ==  ["ab a", "00 0", "01 0", "10 0", "11 1"]
    end

    it "generates the truth table" do
      eq = described_class.new(["a = a & b", "b = a ^ b"])
      eq.to_table.should ==  ["ab ab", "00 00", "01 01", "10 01", "11 10"]
    end
  end
end

