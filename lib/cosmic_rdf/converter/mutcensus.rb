# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Census < Baseurl
      @ignore    = []
      @add_info  = [:gene_name, :accession_number, :hgnc_id, :sample_id]

      def self.identifier(linecnt)
        linecnt
      end

      def self.gene_name
        genename_relation(@row.gene_name)
      end

      def self.accession_number
        genesymbol_relation(@row.accession_number)
      end

      def self.hgnc_id
        hgnc_relation(@row.hgnc_id)
      end
      
      def self.sample_id
        sampleid_relation(@row.sample_id)
      end
      
      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREFIX[:study],
        ]
      end

      def self.rdf_catalog
        header = <<'          END'
          mutation:
              a dcat:Dataset ;
              dct:title COSMIC MUTATION CENSUS ;
              rdfs:label cosmic mutation census ;
              dcat:keyword "mutation" ;
              dcat:distribution :CosmicMutantExportCensus.tsv.gz;
              dcterms:language lang:en ;
              .
          END
      end
      
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
