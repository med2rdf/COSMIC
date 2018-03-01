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
        ## gene, reference, start, end, isFoward, isFuzy
        pos_list = []
        if pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)_(.+){(.+)}:r\.(\d+)\+(\d+)_(\d+)\+(\d+)_(.+){(.+)}:r.(\d+)_(\d+)/
          # SS18{ENST00000415083}:r.1_1286_SS18{ENST00000269138}:r.1286+683_1286+701_SSX2{NM_003147.4}:r.389_1448
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), false]
            pos_list << [$5, $6, $7, $9, is_foward($7, $9), true]
            pos_list << [$11, $12, $13, $14, is_foward($13, $14), false]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_\((\d+)\)_(.+){(.+)}:r\.\((\d+)\)_(\d+)_(.+){(.+)}:r.(\d+)_(\d+)/
          # FUS{ENST00000254108}:r.1_(608)_FUS{ENST00000254108}:r.(819)_937_DDIT3{ENST00000547303}:r.76_872
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), false]
            pos_list << [$5, $6, $7, $8, is_foward($7, $8), false]
            pos_list << [$9, $10, $11, $12, is_foward($11, $12), false]
          
        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)_(.+){(.+)}:r\.(\d+)_(\d+)_(.+){(.+)}:r.(\d+)_(\d+)/
         #  "TMPRSS2{ENST00000332149}:r.1_150_ERG{AY204740.1}:r.226_320_ERG{ENST00000442448}:r.312_5034"
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), false]
            pos_list << [$5, $6, $7, $8, is_foward($7, $8), false]
            pos_list << [$9, $10, $11, $12, is_foward($11, $12), false]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)_(.+){(.+)}:r\.(\d+)_(\d+)/
            pos_list << [$1, $2, $3, $4,  is_foward($3, $4), false]
            pos_list << [$5, $6, $7, $8,  is_foward($7, $8), false]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)\+(\d+)_(.+){(.+)}:r\.(\d+)-(\d+)_(\d+)/
            #         TRIM27{ENST00000377199}:r.1_1104+6742_RET{ENST00000355710}:r.2369-1668_5659
            #pos_list << [$1, $2, $3, "\"#{$4}+#{$5}\"",  is_foward($3, $4)]
            #pos_list << [$6, $7, "\"#{$8}-#{$9}\"", $10, is_foward($8, $10)]
            pos_list << [$1, $2, $3, $4,  is_foward($3, $4), true]
            pos_list << [$6, $7, $8, $10, is_foward($8, $10), true]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)(.+)_(.+){(.+)}:r\.(\d+)_(\d+)/
          #        TMPRSS2{ENST00000332149}:r.1_79+?_ERG{ENST00000442448}:r.312_5034
            # pos_list << [$1, $2, $3, "\"#{$4}+#{$5}\"", is_foward($3, $4)]
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), true]
            pos_list << [$6, $7, $8, $9, is_foward($8, $9), false]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)_(.+){(.+)}:r\.(\d+)-(\d+)_(\d+)/
            #       TOP3A{ENST00000321105}:r.1_93_KMT2A{NM_005933.1}:r.4219-68_11910
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), false]
            #pos_list << [$5, $6, "\"#{$7}-#{$8}\"", $9, is_foward($7, $9)]
            pos_list << [$5, $6, $7, $9, is_foward($7, $9), true]

        elsif pos =~ /(.+){(.+)}:r\.\((\d+)\-(\d+)_(\d+)\-(\d+)\)_(.+){(.+)}:r\.(\d+)-(\d+)_(\d+)/
          #       TMPRSS2{ENST00000332149}:r.(1-8047_1-8000)_ETV4{ENST00000319349}:r.322-19_2391
            #pos_list << [$1, $2, "\"#{$3}-#{$4}\"", "\"#{$5}-#{$6}\"", is_foward($4, $6)]
            #pos_list << [$7, $8, "\"#{$9}-#{$10}\"", $11, is_foward($9, $11)]
            pos_list << [$1, $2, $3, $6, is_foward($4, $6), true]
            pos_list << [$7, $8, $9, $11, is_foward($9, $11), true]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)-\((\d+)\)_(\d+)(.+)_(.+){(.+)}:r\.(\d+)_(\d+)/
          #  TMPRSS2{ENST00000332149}:r.1-(1500)_373_ETV5{ENST00000306376}:r.174_4111
            # pos_list << [$1, $2, "\"#{$3}-#{$4}\"", $5, is_foward($3, $5)]
            pos_list << [$1, $2, $3, $5, is_foward($3, $5), true]
            pos_list << [$7, $8, $9, $10, is_foward($9, $10), false]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)(.+)_(.+){(.+)}:r\.(\d+)-(.+)_(\d+)/
          #  STIL{ENST00000360380}:r.1_112+?_TAL1{ENST00000371884}:r.1-?_4642
            #pos_list << [$1, $2, $3, "\"#{$4}#{$5}\"", is_foward($3, $4)]
            #pos_list << [$6, $7, "\"#{$8}#{$9}\"", $10, is_foward($8, $10)]
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), true]
            pos_list << [$6, $7, $8, $10, is_foward($8, $10), true]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_\((\d+)_(\d+)\)_(.+){(.+)}:r\.(\d+)-\((\d+)_(\d+)\)_(\d+)/
          #    FUS{ENST00000254108}:r.1_(866_868)_ERG{ENST00000442448}:r.1141-(1575_1577)_5034
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), true]
            pos_list << [$6, $7, $8, $11, is_foward($8, $11), false]

        elsif pos =~ /(.+){(.+)}:r\.(\d+)_(\d+)\+(\d+)_(.+){(.+)}:r(\d+)-(\d+)_(\d+)/
          # DNAJB1{ENST00000254322}:r.1_282+320_PRKACA{ENST00000308677}:r244-3566_2677
            #pos_list << [$1, $2, $3, "#{$4}+#{$5}", is_foward($3, $4)]
            #pos_list << [$6, $7, "#{$8}-#{$9}", $10, is_foward($8, $10)]
            pos_list << [$1, $2, $3, $4, is_foward($3, $4), true]
            pos_list << [$6, $7, $8, $10, is_foward($8, $10), true]

        else
          # puts "no position #{pos}"
          return "."
        end

        ## fail 
        pos_list.each do |pos|
          p pos unless  pos[0] =~ /^[A-Z0-9]*$/
          return "." unless  pos[0] =~ /^[A-Z0-9]*$/
        end

        ## rdf_ttl
        faldo_position(pos_list, met_item.fusion_id.first)
      end

      def self.is_foward(srt_pos, end_pos)
        s = srt_pos.to_i
        e = end_pos.to_i
        return true if s < e
        # puts "#{srt_pos} #{end_pos}"
        return false
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
          ## pos : gene, reference, start, end, isFoward, isFuzy
          faldo_strand_position = pos[4] ? "faldo:ForwardStrandPosition" : "faldo:ReverseStrandPosition"
          faldo_fuzy_position   = pos[5] ? "faldo:FuzzyPosition" : "faldo:ExactPosition"
          cnt += 1
          rdf_ttl << "fusion:COSF#{fusion_id}##{cnt} sio:SIO_000300 #{cnt} ;"
          rdf_ttl << "  cosmic:gene <#{CosmicRdf::URIs[:hgnc]}#{pos[0]}> ;"
          rdf_ttl << "  faldo:location ["
          rdf_ttl << "    a faldo:Region ;"
          rdf_ttl << "    faldo:begin ["
          rdf_ttl << "      a #{faldo_fuzy_position}, #{faldo_strand_position} ;"
          rdf_ttl << "      faldo:position #{pos[2]} ;"
          rdf_ttl << "      faldo:reference \"#{pos[1]}\" ;"
          rdf_ttl << "    ] ;"
          rdf_ttl << "    faldo:end   [ "
          rdf_ttl << "      a #{faldo_fuzy_position}, #{faldo_strand_position} ;"
          rdf_ttl << "      faldo:position #{pos[3]} ;"
          rdf_ttl << "      faldo:reference \"#{pos[1]}\" ;"
          rdf_ttl << "    ] ;"
          rdf_ttl << "  ] ;"
          rdf_ttl << "."
        end
      return rdf_ttl        
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
