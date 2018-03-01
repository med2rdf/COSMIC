# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Sample < Tsv
      HEADERS = {
        'sample id' => {
          name: :sample_id,
          fmt:  :i
        },
        'sample_name' => {
          name: :sample_name,
          fmt:  :s
        },
#        'id_tumour' => {
#          name: :tumor_id,
#          fmt:  :i
#        },
#        'id_ind' => {
#          name: :ind_id,
#          fmt:  :i
#        },
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
        'therapy_relationship' => {
          name: :therapy_relationship,
          fmt:  :s
        },
        'sample_differentiator' => {
          name: :sample_differentiator,
          fmt:  :s
        },
        'mutation_allele_specification' => {
          name: :mutation_allele_specification,
          fmt:  :s
        },
        'msi' => {
          name: :msi,
          fmt:  :s
        },
 #       'average_ploidy' => {
 #         name: :average_ploidy,
 #         fmt:  :f
 #       },
        'whole_genome_screen' => {
          name: :whole_genome_screen,
          fmt:  :b
        },
        'whole_exome_screen' => {
          name: :whole_exome_screen,
          fmt:  :b
        },
        'sample_remark' => {
          name: :sample_remark,
          fmt:  :s
        },
        'drug_response' => {
          name: :drug_response,
          fmt:  :s
        },
        'grade' => {
          name: :grade,
          fmt:  :s
        },
        'age_at_tumour_recurrence' => {
          name: :age_at_tumour_recurrence,
          fmt:  :i
        },
        'stage' => {
          name: :stage,
          fmt:  :s
        },
        'cytogenetics' => {
          name: :cytogenetics,
          fmt:  :s
        },
        'metastatic_site' => {
          name: :metastatic_site,
          fmt:  :s
        },
        'tumour_source' => {
          name: :tumour_source,
          fmt:  :s
        },
        'tumour_remark' => {
          name: :tumour_remark,
          fmt:  :s
        },
        'age' => {
          name: :age,
          fmt:  :i
        },
        'ethnicity' => {
          name: :ethnicity,
          fmt:  :s
        },
        'environmental_variables' => {
          name: :environmental_variables,
          fmt:  :s
        },
        'germline_mutation' => {
          name: :germline_mutation,
          fmt:  :s
        },
        'therapy' => {
          name: :therapy,
          fmt:  :s
        },
        'family' => {
          name: :family,
          fmt:  :s
        },
        'normal_tissue_tested' => {
          name: :normal_tissue_tested,
          fmt:  :b
        },
        'gender' => {
          name: :gender,
          fmt:  :s
        },
        'individual_remark' => {
          name: :individual_remark,
          fmt:  :s
        },
        'NCI code' => {
          name: :nci_code,
          fmt:  :s
        }
      }.freeze
    end
  end
end
