require 'bundler/setup'
Bundler.require(:default)
require 'rubygems'
require 'yaml'
require 'qu_function'
require File.expand_path('../equation_to_table', __FILE__)

gw15 = [
	"v = a ^  b",
	"w = c ^  d",
]

gw16 = [
  "v= (a ^ e)&~f  ^  d&~f&g",
  "w= (b ^ c)&(~f&g) ^ (e&f&~g)",
  "x= (a ^ b ^ c ^ d)&f ^  (c^ d^e)&f&g",
  "y= (b ^ c ^ d)&~f&~g",
  "z= (c ^ d)&f&g",
]

gw17 = [
  "v= (a ^ e)&~f  ^  d^~f&g",
  "w= (b ^ c)&~f&g  ^  e&f&~g",
  "x= (a ^ b  ^  c  ^  d)&f  ^   (c  ^  d  ^  e)&f&g",
  "y= (b  ^ c  ^  d)&~f&~g",
  "z= (c  ^  d)&f&g",
]

gw19 = [
"v= (a  ^  b)*((~f&~g&~h)  ^  (~f&~g&j)  ^  g) ^  d&(~f&~g&j  ^  ~f&~g&j  ^  ~f&~g&h   ^  f&~g)",
"w=  d&(~f&~g&~h  ^  ~f&~g&j  ^  g) ^   (a  ^  b)& (~f&~g&j  ^  ~f&~g&j  ^  ~f&~g&h   ^  f&~g)",
"y= c",
]

gw20 = [
  "v= ~a&~b",
  "w= ~a&b&(a  ^  b) ^  a&~b  ^  d&a&~b",
  "x= ~a&b&(c  ^  d) ^  (a&d)",
  "y= a&b&(a  ^  b) ^  (a&b&c)",

]

gw21 = [
"v= (b  ^  c)&~g  ^   (a  ^  b)&~f&g  ^   (b  ^  c)&f&~g",
"w= (a  ^  d)&~f&~g",
"x= (a  ^  b)&f&g  ^   (a  ^  d)&f&~g",
"y= (c  ^  d)&g  ^   (b  ^  c)&~f&g",

]

gw22 = [
"v= (b  ^  c  ^  d)&~f&~g  ^   (a  ^  b)&f&~g&h",
"w= (a  ^  b  ^  c)&~f&g  ^  a&~f&~g&h  ^   (c  ^  d)&f&~g&h",
"x= (a  ^  b  ^  c)&f&h  ^  (c  ^  d)&f&~g&~h  ^  a&~f&~g&~h",
"y= d&g  ^   (a  ^  b)&f&~g&~h",

]

gw23 = [
"v= a&~f  ^   (a  ^  d)&(f&h  ^  f&~g)",
"w= b&~f  ^   (b  ^  c)&(f&h  ^  f&~g)",
"x= c&~f  ^  f&g  ^ f&h",
"y= d&~f",

]

gw24 = [ 
"v= ~a&(g  ^  f) ^  a&g",
"w=b&~f&~g  ^  a&~f&g  ^  c&f&g  ^  ~d&f&~g",
"x=b&~f&~g  ^  b&~f&g  ^  c&~f&g  ^  ~(e  ^  b)&f&~g",
"y= a&~f&~g  ^  c&~f&g  ^   (b  ^  c)&f&g",
]

gw25 = [ 
"v=~f&~g  ^   (b  ^  d)&~f",
"w=~f&g  ^   (b  ^  d)&~f",
"x= (a  ^  b)&f&g  ^   (c  ^  d)&f&~g",
"y=~e&f&g  ^   (c  ^  d)&f",
"z=e&f",
]

equations = 'gw25'

eq = EquationToTable.new(eval(equations))
spec = eq.to_table
spec.shift

hash = {
 'signature' => 
  {'function' => equations},
 'inputs' => {
	'radix' => 2,
  'variables' => eq.num_inputs
 },
 'defaults' => {
	'radix' => 2,
 },
 'outputs' => {
	'radix' => 2,
  'variables' => eq.num_outputs
 },
  'specification' => spec
 }


yaml = hash.to_yaml

bijector = QuFunction::Transformers::Bijector.new(yaml)
puts bijector.complete



