module Cordra
  class DigitalObject < Base
    attr_accessor :identifier,
                  :type,
                  :name

    MAX_LIMIT = 12

    def self.list(query = {})
      #retrieve objects list
    end

    def self.find(id)
      #retrieve one specific object
    end

    def initialize(args = {})
      #initialise the object
      super(args)
      #each DO has an associated list of attributes specified in its schema
      self.attributes = parse_attributes(args)
      # each DO has relationships to other DOs
      self.relations = parse_relations(args)
    end

    def parse_attributes(args = {})
      args.fetch("extendedAttributes", []).map { |attribute| Ingredient.new(attribute) }
    end

    def parse_relations(args = {})
      relations = args["objectRelations"]
      if relations
        relation = relations.first.fetch("relations", [])
        relation.map { |relation| relation.new(relation) }
      end
    end
  end
end