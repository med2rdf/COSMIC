# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Struct < Tsv
      HEADERS = {
        'Sample name' => {
          name: :sample_name,
          fmt:  :s
        },
        'Primary site' => {
          name: :primary_site,
          fmt:  :n
        },
        'Site subtype 1' => {
          name: :site_subtype_1,
          fmt:  :n
        },
        'Site subtype 2' => {
          name: :site_subtype_2,
          fmt:  :n
        },
        'Site subtype 3' => {
          name: :site_subtype_3,
          fmt:  :n
        },
        'Primary histology' => {
          name: :primary_histology,
          fmt:  :n
        },
        'Histology subtype 1' => {
          name: :histology_subtype_1,
          fmt:  :n
        },
        'Histology subtype 2' => {
          name: :histology_subtype_2,
          fmt:  :n
        },
        'Histology subtype 3' => {
          name: :histology_subtype_3,
          fmt:  :n
        },
        'Mutation ID' => {
          name: :mutation_id,
          fmt:  :i
        },
        'Mutation Type' => {
          name: :mutation_type,
          fmt:  :s
        },
        'GRCh' => {
          name: :grch,
          fmt:  :i
        },
        'description' => {
          name: :description,
          fmt:  :s
        },
        'PUBMED_PMID' => {
          name: :pmid,
          fmt:  :i
        },
        'ID_STUDY' => {
          name: :study_id,
          fmt:  :i
        }
      }.freeze
    end
  end
end
