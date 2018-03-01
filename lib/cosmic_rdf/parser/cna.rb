# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Cna < Tsv
      HEADERS = {
        'CNV_ID' => {
          name: :cnv_id,
          fmt:  :i
        },
        'ID_GENE' => {
          name: :gene_id,
          fmt:  :i
        },
        'gene_name' => {
          name: :gene_name,
          fmt:  :s
        },
        'ID_SAMPLE' => {
          name: :sample_id,
          fmt:  :i
        },
#        'ID_TUMOUR' => {
#          name: :tumor_id,
#          fmt:  :i
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
#          name: :site_subtype_2,
#          fmt:  :n
#        },
#        'Site subtype 3' => {
#          name: :site_subtype_3,
#          fmt:  :n
#        },
#        'Primary histology' => {
#          name: :primary_histology,
#          fmt:  :n
#        },
#        'Histology subtype 1' => {
#          name: :histology_subtype_1,
#          fmt:  :n
#        },
#        'Histology subtype 2' => {
#          name: :histology_subtype_2,
#          fmt:  :n
#        },
#        'Histology subtype 3' => {
#          name: :histology_subtype_3,
#          fmt:  :n
#        },
#        'SAMPLE_NAME' => {
#          name: :sample_name,
#          fmt:  :s
#        },
        'TOTAL_CN' => {
          name: :total_cn,
          fmt:  :i
        },
        'MINOR_ALLELE' => {
          name: :minor_allele,
          fmt:  :i
        },
        'MUT_TYPE' => {
          name: :mut_type,
          fmt:  :s
        },
        'ID_STUDY' => {
          name: :study_id,
          fmt:  :i
        },
        'GRCh' => {
          name: :grch,
          fmt:  :i
        },
        'Chromosome:G_Start..G_Stop' => {
          name: :genomic_position,
          fmt:  :s
        }
      }.freeze
    end
  end
end
