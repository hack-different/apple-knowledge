# Data Format Guidance

This serves as general guidance to the structured data effort (see `_data`)

## Guidelines

* Group things that go together.  `mach_o.yaml` contains many Mach-O things, because they all relate.  It could have
  been done by creating `mach_o.load_commands.yaml` etc to create a more tabular format, but that is hard for a human
  to think about.  By grouping a few categories that are related, we reduce effort.
* Use canonical form.  As an example, any list of items should be keyed on a fixed identifier (bundle IDs are a good
  example).  Once this is keyed, ensure that you sort the items so that other editors don't face useless merge conflicts
* Machine generate where possible.  By building scripts (generally under `_tools`) that generate or enrich our datasets
  people are able to see where and how they are sourced, as well as updates are reflected.  Attempt to use primary
  sources.  Apple source code, or call-graph / binary analysis are the most obvious methods of this.
* Most elements should have a `description` field which is intended for human documentation and usage.  This can be
  initially populated to `nil`.  Anywhere a documentation value comes from automation, it should use a different name.
  As an example, Kexts have a description as well, but we should call this `kext_description_text` to imply it comes
  from the Kext itself.
* Adding new keys is easy; Redefining is hard.  If there's a chance something may need to be a list, make it a list of
  one to start.  If something might occur on multiple platforms, ensure you leave room for platforms (first appeared
  in version is an example as AMFI.kext was iOS then macOS)
* Use string keys, not symbols.  Yes, I know, but it makes the data readable on more platforms.
* Break things down by a hierarchy.  Mach-O sections belong to segments.  This means that we use a natural grouping
  for the data.  If more than one grouping exists, think of the common case and other tools can pivot the data.
* Everything is v0 and subject to change until otherwise noted stable.  Be ready to update your tools.
* File formats should include initial data.  No one can extend a file that doesn't have enough data for an author to
  understand.  Feel free to join the discord and discuss areas where you see gaps.