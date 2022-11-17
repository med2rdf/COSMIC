# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'
class Baseurl_Alt < Baseurl

  # Sample include symbols.
  class Sample_Items < Base_Items
    attr_accessor :sample_id, :zygosity, :loh, :resistance_mutation, :mutation_somatic_status, :pmid, :study_id, :sample_source, :tumour_origin
    def initialize()
      @zygosity = []
      @loh = []
      @resistance_mutation = []
      @mutation_somatic_status = []
      @pmid = []
      @sample_source = []
      @tumour_origin = []
      @sample_id = []
      @study_id = [] 
    end
  end

  def initialize()
    # puts "### #{self.class} ###"
    @primary_items = {}
    @sample_hash = {}
  end

  # override
  def self.rdf_turtle(linecnt, obj)
    @row = obj
    primary_id = get_key
    smpl_id = @row.sample_id
    mut_items = @primary_items[primary_id] || Primary_Items.new
    smpl_items = @smpl_hash[smpl_id] || Sample_Items.new
    @primary_items[primary_id] = set_items(Primary_Items, mut_items)
    @smpl_hash[smpl_id] = set_items(Sample_Items, smpl_items)
    return nil
  end

  # return rdf.
  def self.alt_puts_rdf(fout)
    @primary_items.each_pair do |name, mut_item|
      # puts "### #{name} is mutation-id"
      rdf_ttl = []
      @after_rdf = []
      @cur_hgnc_id = mut_item.hgnc_id
      @mutid = name.delete('COSM')
      rdf_ttl << "#{@current.to_sym}:#{@mutid}" ## Subject
      rdf_ttl << "  dcat:identifier \"#{name}\" ;"
      
      ## mutation incude sample-ids
      rdf_ttl << sampleids_relation(mut_item.sample_id)


      Mutation_Items.accessors.each do |item|
        puts "caution! duplicate item? #{item} #{mut_item.send(item)}" if 
          mut_item.send(item).size > 1 && item != :sample_id
        val = mut_item.send(item).first
        next if val.nil? || val == ""
        case item
          when :gene_name
            rdf_ttl << gene_name
          when :accession_number
            rdf_ttl << accession_number
          when :gene_cds_length
            rdf_ttl << "  #{@predicate}cds_length #{val} ;"
          when :hgnc_id
            rdf_ttl << hgnc_relation(val)
          when :mutation_cds
            rdf_ttl << mutation_cds(false, val)
          when :mutation_aa
            rdf_ttl << mutation_cds(true, val)
          when :description,:grch,:genomic_position,:snp,:fathmm_prediction,:fathmm_score
            rdf_ttl << default_rdf(item, val)
          else
            ## 
        end
      end
      # 1-mutation data
      rdf_ttl << "."
      fout.puts(rdf_ttl)
      ## after rdf(mutation positions)
      fout.puts(@after_rdf)
    end

    # sample data in mutation-file
    @smpl_hash.each_pair do |name, items|
      rdf_ttl = []
      rdf_ttl << "sample:#{name}" ## Subject
      rdf_ttl << "  dcat:identifier \"COSS#{name}\" ;"
      Sample_Items.accessors.each do |item|
        vals = items.send(item)
        vals.each do |val|
          next if val.nil? || val.to_s.empty?
          case item
            when :zygosity,:loh,:resistance_mutation,:mutation_somatic_status,:sample_source,:tumour_origin
              rdf_ttl << default_rdf(item, val)
            when :study_id
              study = studyid_relation(val)
              rdf_ttl << study unless study.nil?
            when :pmid
              pm = pmid_relation(val)
              rdf_ttl << pm unless pm.nil?
            else
              ## 
          end
        end
      end
      # 1-sample data
      rdf_ttl << "."
      fout.puts(rdf_ttl)
    end
  end