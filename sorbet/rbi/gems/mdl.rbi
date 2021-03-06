# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/mdl/all/mdl.rbi
#
# mdl-0.11.0

module MarkdownLint
  def self.run(argv = nil); end
end
class MarkdownLint::CLI
  def run(argv = nil); end
  def self.probe_config_file(path); end
  def self.toggle_list(parts, to_sym = nil); end
  extend Mixlib::CLI::ClassMethods
  extend Mixlib::CLI::InheritMethods
  include Mixlib::CLI
end
module MarkdownLint::Config
  def self.config_context_hashes; end
  def self.config_context_hashes=(arg0); end
  def self.config_context_lists; end
  def self.config_context_lists=(arg0); end
  def self.config_contexts; end
  def self.config_contexts=(arg0); end
  def self.config_parent; end
  def self.config_parent=(arg0); end
  def self.configurables; end
  def self.configurables=(arg0); end
  def self.configuration; end
  def self.configuration=(arg0); end
  def self.style(*args, &block); end
  def self.style=(value); end
  extend Mixlib::Config
end
module Kramdown
end
module Kramdown::Parser
end
class Kramdown::Parser::MarkdownLint < Kramdown::Parser::Kramdown
  def initialize(source, options); end
end
class MarkdownLint::Doc
  def add_annotations(elements, level = nil, parent = nil); end
  def element_line(element); end
  def element_linenumber(element); end
  def element_linenumbers(elements); end
  def element_lines(elements); end
  def elements; end
  def extract_text(element, prefix = nil, restore_whitespace = nil); end
  def find_type(type, nested = nil); end
  def find_type_elements(type, nested = nil, elements = nil); end
  def find_type_elements_except(type, nested_except = nil, elements = nil); end
  def header_style(header); end
  def indent_for(line); end
  def initialize(text, ignore_front_matter = nil); end
  def lines; end
  def list_style(item); end
  def matching_lines(regex); end
  def matching_text_element_lines(regex, exclude_nested = nil); end
  def offset; end
  def parsed; end
  def self.new_from_file(filename, ignore_front_matter = nil); end
end
class MarkdownLint::Rule
  def aliases(*aliases); end
  def check(&block); end
  def description; end
  def description=(arg0); end
  def id; end
  def id=(arg0); end
  def initialize(id, description, block); end
  def params(params = nil); end
  def tags(*tags); end
end
class MarkdownLint::RuleSet
  def initialize; end
  def load(rules_file); end
  def load_default; end
  def rule(id, description, &block); end
  def rules; end
end
class MarkdownLint::Style
  def all; end
  def exclude_rule(id); end
  def exclude_tag(tag); end
  def initialize(all_rules); end
  def rule(id, params = nil); end
  def rules; end
  def self.load(style_file, rules); end
  def tag(tag); end
end
