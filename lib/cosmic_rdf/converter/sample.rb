# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Sample < Baseurl
      @ignore = []
      @add_info = [:age, :gender, :sample_name, :sample_id, :nci_code]

      @title = "COSMIC SAMPLE"
      @label = "cosmic sample"
      @keyword = "cancer, tumor, mutation"
      @distribution = "CosmicSample.tsv.gz"

      def self.identifier_relation(ident)
        "sample:#{ident} #{so_type}"
      end

      def self.ident
        @row.sample_id
      end

      def self.sample_id
        return "  dcat:identifier \"COSS#{@row.sample_id}\" ;"
        #return sampleid_relation(@row.sample_id)
        #return  "  #{@predicate}samp_ld [\n" +
        #        "    dcat:identifier \"COSS#{@row.sample_id}\";\n" +
        #        "    dcat:title \"COSMIC sample ID\"; \n" +
        #        "    rdfs:seeAlso <#{CosmicRdf::URIs[:sample]}#{@row.sample_id}>\n" +
        #        "  ];"
        
      end

      def self.gender
        disp = "unknown"
        disp = "female" if @row.gender == 'f'
        disp = "man" if @row.gender == 'm'
        # return disp
        "  dbp:gender \"#{disp}\"; \n"
      end

      def self.sample_name
        return tcga_sample_relation(@row.sample_name)
      end

      def self.age
        rdf_age = nil
        rdf_age = "  foaf:age #{@row.age};" if @row.age != nil && @row.age =~ /^[0-9]+$/
        return rdf_age
      end

      def self.nci_code
        return "" +
              "  #{@predicate}nci_code \"#{@row.nci_code}\" ;\n" +
              "  rdfs:seeAlso <#{CosmicRdf::URIs[:nci]}#{@row.nci_code}> ;"
      end



      def self.alt_puts_rdf(f)
      end

      def self.use_prefix
        prefix =[
          # CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREFIX[:nci_type],
        ]
      end
    end
  end
end