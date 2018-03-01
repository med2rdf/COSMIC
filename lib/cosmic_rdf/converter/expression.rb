# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Expression < Baseurl
      @ignore = [:z_score]
      @add_info = [:sample_id, :gene_name, :regulation]

      @title = "COSMIC CompleteGeneExpression"
      @label = "gene expression level 3 data from the TCGA portal"
      @keyword = "gene expression"
      @distribution = "CosmicCompleteGeneExpression.tsv.gz"

      # return rdf.
      def self.alt_puts_rdf(fout)
      end
      
      def self.ident
        @row.sample_id
      end
      
      def self.sample_id
        "  dcat:identifier \"COSS#{@row.sample_id}\" ;"
      end

      def self.gene_name
        genename_relation(@row.gene_name)
      end

      def self.regulation
        rdf_ttl = []
        rdf_ttl << "  cosmic:regulation [" 
        rdf_ttl << "    a obo:NCIT_C68821 ; "
        rdf_ttl << "    #{@predicate}z_score \"#{@row.z_score}\" ;"
        rdf_ttl << "    rdfs:label \"#{@row.regulation}\" ;"
        rdf_ttl << "  ];"
        return rdf_ttl
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:sample],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
