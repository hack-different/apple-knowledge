# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/iniparse/all/iniparse.rbi
#
# iniparse-1.5.0

module IniParse
  def gen(&blk); end
  def open(path); end
  def parse(source); end
  def self.gen(&blk); end
  def self.open(path); end
  def self.parse(source); end
end
class IniParse::Document
  def [](key); end
  def delete(*args); end
  def each(*args, &blk); end
  def has_section?(key); end
  def initialize(path = nil); end
  def inspect; end
  def lines; end
  def path; end
  def path=(arg0); end
  def save(path = nil); end
  def section(key); end
  def to_h; end
  def to_hash; end
  def to_ini; end
  def to_s; end
  include Enumerable
end
class IniParse::Generator
  def blank; end
  def comment(comment, opts = nil); end
  def context; end
  def document; end
  def gen; end
  def initialize(opts = nil); end
  def line_options(given_opts); end
  def method_missing(name, *args, &blk); end
  def option(key, value, opts = nil); end
  def section(name, opts = nil); end
  def self.gen(opts = nil, &blk); end
  def with_options(opts = nil); end
end
module IniParse::LineCollection
  def <<(line); end
  def [](key); end
  def []=(key, value); end
  def delete(key); end
  def each(include_blank = nil); end
  def has_key?(*args); end
  def initialize; end
  def keys; end
  def push(line); end
  def to_a; end
  def to_h; end
  def to_hash; end
  include Enumerable
end
class IniParse::SectionCollection
  def <<(line); end
  include IniParse::LineCollection
end
class IniParse::OptionCollection
  def <<(line); end
  def each(*args); end
  def keys; end
  include IniParse::LineCollection
end
module IniParse::Lines
end
module IniParse::Lines::Line
  def blank?; end
  def comment; end
  def has_comment?; end
  def initialize(opts = nil); end
  def line_contents; end
  def options; end
  def to_ini; end
end
class IniParse::Lines::Section
  def [](key); end
  def []=(key, value); end
  def delete(*args); end
  def each(*args, &blk); end
  def has_option?(key); end
  def initialize(key, opts = nil); end
  def key; end
  def key=(arg0); end
  def line_contents; end
  def lines; end
  def merge!(other); end
  def option(key); end
  def self.parse(line, opts); end
  def to_ini; end
  include Enumerable
  include IniParse::Lines::Line
end
class IniParse::Lines::AnonymousSection < IniParse::Lines::Section
  def initialize; end
  def line_contents; end
  def to_ini; end
end
class IniParse::Lines::Option
  def initialize(key, value, opts = nil); end
  def key; end
  def key=(arg0); end
  def line_contents; end
  def self.parse(line, opts); end
  def self.typecast(value); end
  def value; end
  def value=(arg0); end
  include IniParse::Lines::Line
end
class IniParse::Lines::Blank
  def blank?; end
  def self.parse(line, opts); end
  include IniParse::Lines::Line
end
class IniParse::Lines::Comment < IniParse::Lines::Blank
  def comment; end
  def has_comment?; end
end
class IniParse::Parser
  def initialize(source); end
  def parse; end
  def self.parse_line(line); end
  def self.parse_types; end
  def self.parse_types=(types); end
  def self.strip_comment(line, opts); end
  def self.strip_indent(line, opts); end
end
class IniParse::IniParseError < StandardError
end
class IniParse::ParseError < IniParse::IniParseError
end
class IniParse::NoSectionError < IniParse::ParseError
end
class IniParse::LineNotAllowed < IniParse::IniParseError
end
