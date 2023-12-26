# typed: true
# frozen_string_literal: true

# Data file for the IOReg data
class IORegData < DataFile
  def initialize
    super('ioreg.yaml')

    @classes = []

    @data['classes'].each do |single_class|
      @classes << IORegClass.load_one(single_class)
    end
  end

  def data
    @data = {}
    @data['classes'] = @classes.map(&:to_h)
  end
end

# A single IOKit class
class IORegClass
  attr_accessor :description, :name, :parents, :known_names

  def initialize(klass_name)
    @name = klass_name
    @parents = []
  end

  def self.for_name(name)
    @instances ||= {}

    @instances[name] = IORegClass.new name unless @instances.key? name

    @instances[name]
  end

  def self.values
    @instances.values.sort_by(&:name)
  end

  def self.load_one(hash)
    instance = for_name hash['name']
    instance.description = hash['description']
    instance.parents = hash['parents']
    instance.known_names = (hash['known_names'] || []).sort
  end

  def to_h
    { 'name' => @name, 'description' => @description, 'parents' => @parents, 'known_names' => @known_names }
  end

  def user_client?
    @parents.include? 'IOUserClient'
  end
end
