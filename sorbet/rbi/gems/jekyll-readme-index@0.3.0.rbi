# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `jekyll-readme-index` gem.
# Please instead update this file by running `bin/tapioca gem jekyll-readme-index`.

# Public: Methods that generate a URL for a resource such as a Post or a Page.
#
# Examples
#
#   URL.new({
#     :template => /:categories/:title.html",
#     :placeholders => {:categories => "ruby", :title => "something"}
#   }).to_s
#
# source://jekyll-readme-index-0.3.0/lib/jekyll/static_file_ext.rb:3
module Jekyll
  class << self
    # Public: Generate a Jekyll configuration Hash by merging the default
    # options with anything in _config.yml, and adding the given options on top.
    #
    # override - A Hash of config directives that override any options in both
    #            the defaults and the config file.
    #            See Jekyll::Configuration::DEFAULTS for a
    #            list of option names and their defaults.
    #
    # Returns the final configuration Hash.
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:114
    def configuration(override = T.unsafe(nil)); end

    # Public: Tells you which Jekyll environment you are building in so you can skip tasks
    # if you need to.  This is useful when doing expensive compression tasks on css and
    # images and allows you to skip that when working in development.
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:101
    def env; end

    # Public: Fetch the logger instance for this Jekyll process.
    #
    # Returns the LogAdapter instance.
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:145
    def logger; end

    # Public: Set the log writer.
    #         New log writer must respond to the same methods
    #         as Ruby's interal Logger.
    #
    # writer - the new Logger-compatible log transport
    #
    # Returns the new logger.
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:156
    def logger=(writer); end

    # Public: Ensures the questionable path is prefixed with the base directory
    #         and prepends the questionable path with the base directory if false.
    #
    # base_directory - the directory with which to prefix the questionable path
    # questionable_path - the path we're unsure about, and want prefixed
    #
    # Returns the sanitized path.
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:174
    def sanitized_path(base_directory, questionable_path); end

    # Public: Set the TZ environment variable to use the timezone specified
    #
    # timezone - the IANA Time Zone
    #
    # Returns nothing
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:133
    def set_timezone(timezone); end

    # Public: An array of sites
    #
    # Returns the Jekyll sites created.
    #
    # source://jekyll-4.2.2/lib/jekyll.rb:163
    def sites; end
  end
end

# source://jekyll-readme-index-0.3.0/lib/jekyll/static_file_ext.rb:13
class Jekyll::Page
  # Initialize a new Page.
  #
  # site - The Site object.
  # base - The String path to the source.
  # dir  - The String path between the source and the file.
  # name - The String filename of the file.
  #
  # @return [Page] a new instance of Page
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:39
  def initialize(site, base, dir, name); end

  # Returns the value of attribute basename.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def basename; end

  # Sets the attribute basename
  #
  # @param value the value to set the attribute basename to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def basename=(_arg0); end

  # Returns the value of attribute content.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:10
  def content; end

  # Sets the attribute content
  #
  # @param value the value to set the attribute content to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:10
  def content=(_arg0); end

  # Returns the value of attribute data.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:10
  def data; end

  # Sets the attribute data
  #
  # @param value the value to set the attribute data to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:10
  def data=(_arg0); end

  # Obtain destination path.
  #
  # dest - The String path to the destination dir.
  #
  # Returns the destination file path String.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:155
  def destination(dest); end

  # The generated directory into which the page will be placed
  # upon generation. This is derived from the permalink or, if
  # permalink is absent, will be '/'
  #
  # Returns the String destination directory.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:66
  def dir; end

  # Sets the attribute dir
  #
  # @param value the value to set the attribute dir to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:7
  def dir=(_arg0); end

  # source://jekyll-4.2.2/lib/jekyll/page.rb:192
  def excerpt; end

  # source://jekyll-4.2.2/lib/jekyll/page.rb:188
  def excerpt_separator; end

  # Returns the value of attribute ext.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def ext; end

  # Sets the attribute ext
  #
  # @param value the value to set the attribute ext to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def ext=(_arg0); end

  # Returns the value of attribute ext.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def extname; end

  # @return [Boolean]
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:198
  def generate_excerpt?; end

  # Returns the Boolean of whether this Page is HTML or not.
  #
  # @return [Boolean]
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:171
  def html?; end

  # Returns the Boolean of whether this Page is an index file or not.
  #
  # @return [Boolean]
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:176
  def index?; end

  # Returns the object as a debug String.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:166
  def inspect; end

  # Returns the value of attribute name.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def name; end

  # Sets the attribute name
  #
  # @param value the value to set the attribute name to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:9
  def name=(_arg0); end

  # Returns the value of attribute output.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:10
  def output; end

  # Sets the attribute output
  #
  # @param value the value to set the attribute output to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:10
  def output=(_arg0); end

  # Returns the value of attribute pager.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:8
  def pager; end

  # Sets the attribute pager
  #
  # @param value the value to set the attribute pager to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:8
  def pager=(_arg0); end

  # The path to the source file
  #
  # Returns the path to the source file
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:141
  def path; end

  # The full path and filename of the post. Defined in the YAML of the post
  # body.
  #
  # Returns the String permalink or nil if none has been set.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:74
  def permalink; end

  # Extract information from the page filename.
  #
  # name - The String filename of the page file.
  #
  # NOTE: `String#gsub` removes all trailing periods (in comparison to `String#chomp`)
  # Returns nothing.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:118
  def process(name); end

  # The path to the page source file, relative to the site source
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:146
  def relative_path; end

  # Add any necessary layouts to this post
  #
  # layouts      - The Hash of {"name" => "layout"}.
  # site_payload - The site payload Hash.
  #
  # Returns String rendered page.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:131
  def render(layouts, site_payload); end

  # Returns the value of attribute site.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:8
  def site; end

  # Sets the attribute site
  #
  # @param value the value to set the attribute site to.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:8
  def site=(_arg0); end

  # The template of the permalink.
  #
  # Returns the template String.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:81
  def template; end

  # source://jekyll-4.2.2/lib/jekyll/page.rb:180
  def trigger_hooks(hook_name, *args); end

  # source://jekyll-readme-index-0.3.0/lib/jekyll/static_file_ext.rb:14
  def update_permalink; end

  # The generated relative url of this page. e.g. /about.html.
  #
  # Returns the String url.
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:94
  def url; end

  # Returns a hash of URL placeholder names (as symbols) mapping to the
  # desired placeholder replacements. For details see "url.rb"
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:104
  def url_placeholders; end

  # @return [Boolean]
  #
  # source://jekyll-4.2.2/lib/jekyll/page.rb:184
  def write?; end

  private

  # source://jekyll-4.2.2/lib/jekyll/page.rb:204
  def generate_excerpt; end

  # source://jekyll-4.2.2/lib/jekyll/page.rb:210
  def url_dir; end
end

# Attributes for Liquid templates
#
# source://jekyll-4.2.2/lib/jekyll/page.rb:15
Jekyll::Page::ATTRIBUTES_FOR_LIQUID = T.let(T.unsafe(nil), Array)

# A set of extensions that are considered HTML or HTML-like so we
# should not alter them,  this includes .xhtml through XHTM5.
#
# source://jekyll-4.2.2/lib/jekyll/page.rb:27
Jekyll::Page::HTML_EXTENSIONS = T.let(T.unsafe(nil), Array)

# source://jekyll-readme-index-0.3.0/lib/jekyll/static_file_ext.rb:4
class Jekyll::StaticFile
  # Initialize a new StaticFile.
  #
  # site - The Site.
  # base - The String path to the <source>.
  # dir  - The String path between <source> and the file.
  # name - The String filename of the file.
  #
  # @return [StaticFile] a new instance of StaticFile
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:29
  def initialize(site, base, dir, name, collection = T.unsafe(nil)); end

  # Generate "basename without extension" and strip away any trailing periods.
  # NOTE: `String#gsub` removes all trailing periods (in comparison to `String#chomp`)
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:125
  def basename; end

  # Similar to Jekyll::Document#cleaned_relative_path.
  # Generates a relative path with the collection's directory removed when applicable
  #   and additionally removes any multiple periods in the string.
  #
  # NOTE: `String#gsub!` removes all trailing periods (in comparison to `String#chomp!`)
  #
  # Examples:
  #   When `relative_path` is "_methods/site/my-cool-avatar...png":
  #     cleaned_relative_path
  #     # => "/site/my-cool-avatar"
  #
  # Returns the cleaned relative path of the static file.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:151
  def cleaned_relative_path; end

  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:115
  def data; end

  # Returns the front matter defaults defined for the file's URL and/or type
  # as defined in _config.yml.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:184
  def defaults; end

  # Obtain destination path.
  #
  # dest - The String path to the destination dir.
  #
  # Returns destination file path.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:57
  def destination(dest); end

  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:62
  def destination_rel_dir; end

  # Returns the value of attribute extname.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:7
  def extname; end

  # Returns a debug string on inspecting the static file.
  # Includes only the relative path of the object.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:190
  def inspect; end

  # Is source path modified?
  #
  # Returns true if modified since last write.
  #
  # @return [Boolean]
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:82
  def modified?; end

  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:70
  def modified_time; end

  # Returns last modification time for this file.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:75
  def mtime; end

  # Returns the value of attribute name.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:7
  def name; end

  # Returns source file path.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:41
  def path; end

  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:129
  def placeholders; end

  # Returns the value of attribute relative_path.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:7
  def relative_path; end

  # source://RUBY_ROOT/forwardable.rb:229
  def to_json(*args, **_arg1, &block); end

  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:119
  def to_liquid; end

  # Convert this static file to a Page
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll/static_file_ext.rb:6
  def to_page; end

  # Returns the type of the collection if present, nil otherwise.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:178
  def type; end

  # Applies a similar URL-building technique as Jekyll::Document that takes
  # the collection's URL template into account. The default URL template can
  # be overriden in the collection's configuration in _config.yml.
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:163
  def url; end

  # Write the static file to the destination directory (if modified).
  #
  # dest - The String path to the destination dir.
  #
  # Returns false if the file was not modified since last time (no-op).
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:102
  def write(dest); end

  # Whether to write the file to the filesystem
  #
  # Returns true unless the defaults for the destination path from
  # _config.yml contain `published: false`.
  #
  # @return [Boolean]
  #
  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:90
  def write?; end

  private

  # source://jekyll-4.2.2/lib/jekyll/static_file.rb:196
  def copy_file(dest_path); end

  class << self
    # The cache of last modification times [path] -> mtime.
    #
    # source://jekyll-4.2.2/lib/jekyll/static_file.rb:13
    def mtimes; end

    # source://jekyll-4.2.2/lib/jekyll/static_file.rb:17
    def reset_cache; end
  end
end

# source://jekyll-4.2.2/lib/jekyll/version.rb:4
Jekyll::VERSION = T.let(T.unsafe(nil), String)

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:3
module JekyllReadmeIndex; end

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:4
class JekyllReadmeIndex::Generator < ::Jekyll::Generator
  # @return [Generator] a new instance of Generator
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:17
  def initialize(site); end

  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:21
  def generate(site); end

  # Returns the value of attribute site.
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:7
  def site; end

  # Sets the attribute site
  #
  # @param value the value to set the attribute site to.
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:7
  def site=(_arg0); end

  private

  # @return [Boolean]
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:85
  def cleanup?; end

  # Does the given directory have an index?
  #
  # relative_path - the directory path relative to the site root
  #
  # @return [Boolean]
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:62
  def dir_has_index?(relative_path); end

  # @return [Boolean]
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:81
  def disabled?; end

  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:73
  def markdown_converter; end

  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:77
  def option(key); end

  # Regexp to match a file path against to detect if the given file is a README
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:69
  def readme_regex; end

  # Returns an array of all READMEs as StaticFiles
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:44
  def readmes; end

  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:48
  def readmes_with_frontmatter; end

  # Should the given readme be the containing directory's index?
  #
  # @return [Boolean]
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:53
  def should_be_index?(readme); end

  # @return [Boolean]
  #
  # source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:89
  def with_frontmatter?; end

  class << self
    # source://jekyll-4.2.2/lib/jekyll/plugin.rb:24
    def inherited(const_); end
  end
end

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:14
JekyllReadmeIndex::Generator::CLEANUP_KEY = T.let(T.unsafe(nil), String)

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:12
JekyllReadmeIndex::Generator::CONFIG_KEY = T.let(T.unsafe(nil), String)

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:13
JekyllReadmeIndex::Generator::ENABLED_KEY = T.let(T.unsafe(nil), String)

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:15
JekyllReadmeIndex::Generator::FRONTMATTER_KEY = T.let(T.unsafe(nil), String)

# source://jekyll-readme-index-0.3.0/lib/jekyll-readme-index/generator.rb:5
JekyllReadmeIndex::Generator::INDEX_REGEX = T.let(T.unsafe(nil), Regexp)
