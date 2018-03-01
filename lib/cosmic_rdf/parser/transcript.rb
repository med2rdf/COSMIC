# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Transcript < Tsv
      HEADERS = {
        'Gene ID' => {
          name: :gene_id,
          fmt:  :i
        },
        'Gene_NAME' => {
          name: :gene_name,
          fmt:  :s
        },
        'Transcript ID' => {
          name: :transcript_id,
          fmt:  :s
        },
      }.freeze
    end
  end
end
