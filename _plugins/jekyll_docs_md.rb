# typed: true
# frozen_string_literal: true

# Convert all markdown static files in collections into documents so they are rendered as HTML
Jekyll::Hooks.register :site, :post_read do |site|
  site.collections.each_value do |collection|
    static_md_files = collection.files.select { |f| ['.md', '.markdown'].include?(f.extname) }
    static_md_files.each do |file|
      doc = Jekyll::Document.new(file.path, site: site, collection: collection)
      doc.read
      # If no front matter was present, doc.data layout falls back to site defaults
      collection.docs << doc
      site.documents << doc
      collection.files.delete(file)
      site.static_files.delete(file)
    end
  end
end
