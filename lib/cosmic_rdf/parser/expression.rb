# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Expression < Tsv
      HEADERS = {
#        'SAMPLE_NAME' => {
#          name: :sample_name,
#          fmt:  :s
#        },
        'SAMPLE_ID' => {
          name: :sample_id,
          fmt:  :i
        },
        'GENE_NAME' => {
          name: :gene_name,
          fmt:  :s
        },
        'REGULATION' => {
          name: :regulation,
          fmt:  :s
        },
        'Z_SCORE' => {
          name: :z_score,
          fmt:  :f
        },
#        'ID_STUDY' => {
#          name: :study_id,
#          fmt:  :i
#        }
      }.freeze
    end
  end
end
