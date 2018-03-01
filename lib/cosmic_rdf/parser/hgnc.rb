# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Hgnc < Tsv
      HEADERS = {
        'COSMIC_ID' => {
          name: :cosmic_id,
          fmt:  :i
        },
        'COSMIC_GENE_NAME' => {
          name: :gene_name,
          fmt:  :s
        },
        'Entrez_id' => {
          name: :entrez_id,
          fmt:  :s
        },
        'HGNC_ID' => {
          name: :hgnc_id,
          fmt:  :i
        },
        'mutated?' => {
          name: :mutated,
          fmt:  :b
        },
        'Cancer_census?' => {
          name: :cancer_census,
          fmt:  :b
        },
        'Expert Curated?' => {
          name: :expert_curated,
          fmt:  :b
        },
      }.freeze
    end
  end
end
