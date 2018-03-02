# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'
module CosmicRdf
  module Converter
    class Fusion < Baseurl
      class Fusion_Items < Base_Items
        attr_accessor :fusion_id,:translocation_name,:fusion_type,:study_id,:sample_id
      end

      class Sample_Items < Base_Items
        attr_accessor :sample_id, :pmid
      end

      @title = "CosmicFusionExport"
      @label = "gene fusion mutation data"
      @keyword = "fusion"
      @distribution = "CosmicFusionExport.tsv.gz"

      @ignore = [:sample_id, :fusion_id]
      @add_info = []

      @met_hash = {}
      @smpl_hash = {}
      def self.rdf_turtle(obj)
        @row = obj
        # id をKeyにしたClassを保持
        met_items  = @met_hash[@row.fusion_id] || Fusion_Items.new
        smpl_items = @smpl_hash[@row.sample_id] || Sample_Items.new
        @met_hash[@row.fusion_id] = set_items(met_items)
        @smpl_hash[@row.sample_id] = set_items(smpl_items)
        return nil
      end

      # return rdf.
      def self.alt_puts_rdf(fout)
        @met_hash.each_pair do |fusion_id, met_item|
          rdf_ttl = []
          rdf_ttl << "#{@current.to_sym}:COSF#{fusion_id} #{so_type}" ## Subject
          rdf_ttl << "  dcat:identifier \"COSF#{fusion_id}\" ;"
          
          # mutation incude sample-ids
          rdf_ttl << sampleids_relation(met_item.sample_id)
 
          Fusion_Items.accessors.each do |item|
            next if @ignore.include?(item)
            puts "caution! duplicate item? #{item} #{met_item.send(item)}" if 
              met_item.send(item).size > 1 && item != :sample_id
            val = met_item.send(item).first
            next  if val.nil? || val == ""
            rdf_ttl <<
            case item
              when :study_id
                studyid_relation(val)
              else default_rdf(item, val)
            end
          end
          ## genome posisition -> faldo
          rdf_ttl << genomic_position(met_item)


          # 1-sample data
          # rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end

      def self.ident
        @row.fusion_id
      end

      def self.sample_id
        return sampleid_relation(@row.sample_id)
      end

      def self.genomic_position(met_item)
        pos = met_item.translocation_name.first
        poslist = pos.split(":")

        break_points = []
        fst_gene_ref = poslist.shift
        lst_pos1_pos2 = poslist.pop
        poslist.each do |part|
          gene, ref = fst_gene_ref.split(/{|}/)
          pospart = {gene: gene, ref: ref}
          #
          p1, p2, gene, ref = parse_mid(part)
          if gene.nil?
            pospart[:p1] =  p1
            pospart[:p2] = "?"
            fst_gene_ref = p2 + "{" + ref  
          else
            pospart[:p1] = p1
            pospart[:p2] = p2
            fst_gene_ref = gene + "{" + ref  
          end
          break_points << pospart
        end 
        ## last
        gene, ref = fst_gene_ref.split(/{|}/)
        pr, p1, p2 = lst_pos1_pos2.split(/\.|_/)
        p2 = "?" if p2.nil?
        break_points << {gene: gene, ref: ref, p1: p1, p2: p2}
        
        ## rdf_ttl
        faldo_position(break_points, met_item.fusion_id.first)
      end

      def self.parse_mid(str)
        str.gsub!("_ins", "+")
        _at = str.split(/{|}/)
        
        ref = _at.pop
        pr, p1, p2, gene = _at.shift.split(/\.|_/)
        # puts "#{pr}/#{p1}/#{p2}/#{gene} "
        [p1, p2, gene, ref]
      end


      def self.faldo_position(pos_list, fusion_id)
        rdf_ttl = []
        subject_line = "  sio:SIO_000974 "
        for i in 1..pos_list.size 
          subject_line += "fusion:COSF#{fusion_id}##{i}, "
        end
        subject_line.sub!(/, $/, "")
        rdf_ttl << subject_line
        rdf_ttl << "."
        cnt = 0
        pos_list.each do |pos|
          ## pos : {gene: ref: p1: p2: }
          faldo_strand_position   = faldo_strand(pos[:p1], pos[:p2])
          faldo_fuzy_position   = faldo_fuzy(pos[:p1], pos[:p2])
          cnt += 1
          rdf_ttl << "fusion:COSF#{fusion_id}##{cnt} sio:SIO_000300 #{cnt} ;"
          rdf_ttl << "  cosmic:gene <#{CosmicRdf::URIs[:hgnc]}#{pos[:gene]}> ;"
          rdf_ttl << "  faldo:location ["
          rdf_ttl << "    a faldo:Region ;"
          rdf_ttl << "    faldo:begin ["
          rdf_ttl << "      a #{faldo_fuzy_position}, #{faldo_strand_position} ;"
          rdf_ttl << "      faldo:position #{pos[:p1]} ;"
          rdf_ttl << "      faldo:reference \"#{pos[:ref]}\" ;"
          rdf_ttl << "    ] ;"
          rdf_ttl << "    faldo:end   [ "
          rdf_ttl << "      a #{faldo_fuzy_position}, #{faldo_strand_position} ;"
          rdf_ttl << "      faldo:position #{pos[:p2]} ;"
          rdf_ttl << "      faldo:reference \"#{pos[:ref]}\" ;"
          rdf_ttl << "    ] ;"
          rdf_ttl << "  ] ;"
          rdf_ttl << "."
        end
        return rdf_ttl        
      end

      def self.faldo_strand(p1, p2)
        if p1 =~ /^[0-9]+$/ && p2 =~ /^[0-9]+$/
          if p1.to_i < p2.to_i
            return "faldo:ForwardStrandPosition"
          else
            return "faldo:ReverseStrandPosition"
          end
        end
        ## ? 
        "faldo:ForwardStrandPosition"
      end
      
      def self.faldo_fuzy(p1, p2)
        if p1 =~ /^[0-9]+$/ && p2 =~ /^[0-9]+$/
          return "faldo:ExactPosition"
        end
        "faldo:FuzzyPosition"
      end


      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREFIX[:sio],
        ]
      end
      
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
