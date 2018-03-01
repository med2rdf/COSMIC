# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Fusion < Tsv
      HEADERS = {
        'Sample ID' => {
          name: :sample_id,
          fmt:  :i
        },
#        'Sample name' => {
#          name: :sample_name,
#          fmt:  :s
#        },
#        'Primary site' => {
#          name: :primary_site,
#          fmt:  :n
#        },
#        'Site subtype 1' => {
#          name: :site_subtype_1,
#          fmt:  :n
#        },
#        'Site subtype 2' => {
 #         name: :site_subtype_2,
 #         fmt:  :n
 #       },
 #       'Site subtype 3' => {
 #         name: :site_subtype_3,
 #         fmt:  :n
 #       },
 #       'Primary histology' => {
 #         name: :primary_histology,
 #         fmt:  :n
 #       },
 #       'Histology subtype 1' => {
 #         name: :histology_subtype_1,
 #         fmt:  :n
 #       },
 #       'Histology subtype 2' => {
 #         name: :histology_subtype_2,
 #         fmt:  :n
 #       },
 #       'Histology subtype 3' => {
 #         name: :histology_subtype_3,
 #         fmt:  :n
 #       },
        'Fusion ID' => {
          name: :fusion_id,
          fmt:  :i
        },
        'Translocation Name' => {
          name: :translocation_name,
          fmt:  :s
        },
        'Fusion Type' => {
          name: :fusion_type,
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

      def each
        super do |row|
          next unless row.fusion_id.present?
          yield row
        end
      end
    end
  end
end
