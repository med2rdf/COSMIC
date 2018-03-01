# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'
module CosmicRdf
  module Converter
    class Mutation < Baseurl
      # Mutation include symbols.
      class Mutation_Items < Base_Items
        attr_accessor :gene_name, :accession_number, :gene_cds_length, :hgnc_id, :mutation_id, :mutation_cds, :mutation_aa, :description, :grch, :genomic_position, :strand, :snp, :fathmm_prediction, :fathmm_score, :sample_id
      end
      # Sample include symbols.
      class Sample_Items < Base_Items
        attr_accessor :sample_id, :zygosity, :loh, :resistance_mutation, :mutation_somatic_status, :pmid, :study_id, :sample_source, :tumour_origin
      end

      @title = "COSMIC MUTATION"
      @label = "cosmic mutation"
      @keyword = "mutation"
      @distribution = "CosmicMutantExport.tsv.gz"

      @ignore = [:mutation_id, :sample_id]
      @add_info = [:gene_id, :gene_name, :accession_number, :genomic_position, :mutation_aa]

      @mut_hash = {}
      @smpl_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        # mutation_id sample_id is hash-key.
        mut_id = @row.mutation_id
        smpl_id = @row.sample_id
        # id をKeyにしたClassを保持
        mut_items = @mut_hash[mut_id] || Mutation_Items.new
        smpl_items = @smpl_hash[smpl_id] || Sample_Items.new
        # それぞれのClassに値を代入
        @mut_hash[mut_id] = set_items(mut_items)
        @smpl_hash[smpl_id] = set_items(smpl_items)
        return nil
      end

      # return rdf.
      def self.alt_puts_rdf(fout)
        @mut_hash.each_pair do |mut_id, mut_item|
          # puts "### #{name} is mutation-id"
          rdf_ttl = []
          @after_rdf = []
          @cur_hgnc_id = mut_item.hgnc_id
          @mutid = mut_id.delete('COSM')
          rdf_ttl << "#{@current.to_sym}:#{@mutid} #{so_type(mut_item.description)}, #{CosmicRdf::RDF_CLASS[:variation]} ;" ## Subject
          rdf_ttl << "  dcat:identifier \"#{mut_id}\" ;"
          
          ## mutation incude sample-ids
          rdf_ttl << sampleids_relation(mut_item.sample_id)

          @row = mut_item
          Mutation_Items.accessors.each do |item|
            puts "caution! duplicate item? #{item} #{mut_item.send(item)}" if 
              mut_item.send(item).size > 1 && item != :sample_id
            val = mut_item.send(item).first
            next  if val.nil? || val.to_s.empty?
            next  if @ignore.include?(item)

            rdf_ttl <<
            case item
              when :gene_name
                    gene_name
              when :accession_number
                    accession_number
              when :hgnc_id
                    hgnc_id
              when :gene_cds_length
                    gene_cds_length
              when :genomic_position
                    genomic_position
              when :mutation_cds
                    mutation_cds
              #when :description,:grch,:genomic_position,:snp,:fathmm_prediction,:fathmm_score
              else
                  default_rdf(item, val)
            end
          end
          # 1-mutation data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
          ## after rdf(mutation positions)
          fout.puts(@after_rdf)
        end

        # sample data in mutation-file
        @smpl_hash.each_pair do |smpl_id, smpl_item|
          rdf_ttl = []
          rdf_ttl << "sample:#{smpl_id} #{CosmicRdf::RDF_CLASS[:sample]}" ## Subject
          rdf_ttl << "  dcat:identifier \"COSS#{smpl_id}\" ;"
          Sample_Items.accessors.each do |item|
            vals = smpl_item.send(item)
            vals.each do |val|
              next if val.nil? || val.to_s.empty?
              case item
                when :study_id
                  study_ttl = studyid_relation(val)
                  rdf_ttl << study_ttl unless study_ttl.nil?
                when :pmid
                  pmid_ttl = pmid_relation(val)
                  rdf_ttl << pmid_ttl unless pmid_ttl.nil?
                else
                  rdf_ttl << default_rdf(item, val)
              end
            end
          end
          # 1-sample data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end

      def self.ident
        @row.mutation_id
      end

      def self.gene_name
        genename_relation(@row.gene_name.first)
      end

      def self.hgnc_id
        hgnc_relation(@row.hgnc_id.first)
      end
      
      def self.accession_number
        genesymbol_relation(@row.accession_number.first)
      end

      def self.gene_cds_length
        "  #{@predicate}cds_length #{@row.gene_cds_length.first} ;"
      end
      
      def self.genomic_position
        pos = @row.genomic_position.first
        rdf_ttl = []
        rdf_ttl << default_rdf("genomic_position", pos)

        chr, pos1 , pos2 = pos.split(/:|-/)
        start_pos, end_pos = genomic_start_end_pos(pos1, pos2)
        return rdf_ttl if start_pos.nil?

        rdf_ttl << genomic_position_relation(start_pos, end_pos, ["grch#{@row.grch.first}", "chr#{chr}"])
        return rdf_ttl
      end

      def self.genomic_start_end_pos(pos1, pos2)
        ## number exception check.
        if pos1.nil? || pos1.empty? || !pos1 =~ /^[0-9]+$/ ||
           pos2.nil? || pos2.empty? || !pos2 =~ /^[0-9]+$/ 
          return nil
        end

        strand = @row.strand.first
        start_pos, end_pos = ""
        if pos1 == pos2    # snp, ins
          if strand == '+'
            start_pos = pos1
            end_pos   = pos2.to_i + 1
          elsif strand == '-'
            start_pos = pos2
            end_pos   = pos1.to_i - 1
          end
          
        else ## del
          if strand == '+'
            start_pos = pos1
            end_pos   = pos2
          elsif strand == '-'
            start_pos = pos2
            end_pos   = pos1
          end
        end

        return nil if start_pos.to_s.empty? || end_pos.to_s.empty? 
        return [start_pos, end_pos]
      end
      
      def self.mutation_cds
        rdf_ttl = []
        rdf_ttl << default_rdf("mutation_cds", @row.mutation_cds.first)
        mut_ref_alt = mutation_nuc(@row.mutation_cds.first)
        rdf_ttl << mut_ref_alt unless mut_ref_alt.nil? || mut_ref_alt.empty?
      end

      def self.so_type(description)
        desc = description.first || "Other"
        rdf_type = "a obo:" +
          case desc
            when "Substitution - Missense" ;          "SO_0001583"
            when "Substitution - coding silent" ;     "SO_0001819"
            when "Frameshift" ;                       "SO_0001589"
            when "Deletion - Frameshift" ;            "SO_0001910"
            when "Insertion - Frameshift" ;           "SO_0001909"
            when "Deletion - In frame" ;              "SO_0001822"
            when "Insertion - In frame" ;             "SO_0001821"
            when "Nonstop extension" ;                "SO_0001578"
            when "Substitution - Nonsense" ;          "SO_0001587"
            when "Complex" ;                          "SO_1000005"
            when "Complex - compound substitution" ;  "SO_1000005"
            when "Complex - insertion inframe" ;      "SO_0001577"
            when "Complex - deletion inframe" ;       "SO_0001577"
            when "Complex - frameshift" ;             "SO_0000865"
            when "Whole gene deletion" ;              "SO_0000045"
            when "Unknown" ;                          "SO_0001060"
            else "SO_0001564"  ## gene_variant
          end
        return rdf_type
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREFIX[:study],
          # CosmicRdf::PREFIX[:hgncurl],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
