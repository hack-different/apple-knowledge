#!/usr/bin/env ruby
# typed: false
# frozen_string_literal: true

require 'jruby'
require 'java'

# TODO: Update this to the correct path
GHIDRA_PATH = '/usr/local/Caskroom/ghidra/10.1.1,20211221/ghidra_10.1.1_PUBLIC/'

require File.join(GHIDRA_PATH, 'Ghidra/Framework/Utility/lib/Utility.jar')

java_import 'ghidra.GhidraClassLoader'
java_import 'ghidra.GhirdaLauncher'

jruby_class_loader = JRuby.runtime.class_loader
JRuby.runtime.class_loader = Java::Ghidra::GhidraClassLoader.new jruby_class_loader

arguments = ['ghidra.GhidraRun'].to_java('java.lang.String')

Java::Ghirda::GhirdaLauncher.launch(arguments)
