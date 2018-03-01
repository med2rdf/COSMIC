# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Hgnc < Baseurl
      @ignore = []
      @add_info = [:entrez_id, :hgnc_id, :gene_name, :cosmic_id]

      @title = "Cosmic HGNC"
      @label = "relationship between the Cancer Gene Census, COSMIC ID, Gene Name, HGNC ID and Entrez ID"
      @keyword = "HGNC ID"
      @distribution = "CosmicHGNC.tsv.gz"

      def self.alt_puts_rdf(fout)
      end
      
      def self.ident
        @row.gene_name
      end

      def self.cosmic_id()
        cosmicgeneid_relation(@row.cosmic_id)
      end
      
      def self.entrez_id
        entrez_id_relation(@row.entrez_id)
      end

      def self.gene_name
        # relation at identifier
        return nil
      end
      
      def self.hgnc_id
        hgnc_relation(@row.hgnc_id)
      end

      def self.so_type
        "a #{CosmicRdf::RDF_CLASS[:gene]} ;"
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREFIX[:ncbigene],
          CosmicRdf::PREFIX[:hgnc],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
