# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Transcript < Baseurl
      @ignore = []
      @add_info = [:gene_id, :transcript_id]

      @title = "CosmicTranscripts"
      @label = "cosmic transcripts"
      @keyword = "transcripts"
      @distribution = "CosmicTranscripts.tsv.gz"

      def self.alt_puts_rdf(fout)
      end
      
      def self.ident
        @row.gene_name
      end

      def self.gene_id
        cosmicgeneid_relation(@row.gene_id)
      end
      
      def self.transcript_id
        genesymbol_relation(@row.transcript_id)
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
