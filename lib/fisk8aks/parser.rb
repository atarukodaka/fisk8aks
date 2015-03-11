require 'mechanize'
require 'pry-byebug'

class String
  Nbsp = Nokogiri::HTML("&nbsp;").text
  def chompsp
    self.gsub(/[\t\r\n]*/, "").gsub(Nbsp, " ").gsub(/^ +/, "").gsub(/ +$/, "")
  end
end

################################################################
module Fisk8aks
  class Parser
    attr_reader :agent
    def initialize
      @agent = Mechanize.new 
    end

    ################
    # skater
    #
    def parse_skaters_discipline(discipline="MEN")
      hash_str = {'MEN' => "men", "LADIES" => "ladies", "PAIR" => "pairs", "ICEDANCE" => "icedancing"}    
      disc_str = hash_str[discipline]
      url = "http://www.isuresults.com/bios/fsbios#{disc_str}.htm"
      $stderr.puts "parsing #{url}..."
      doc = agent.get(url).parser

      skaters = []
      country = nil; noc = nil;
      #binding.pry
      doc.xpath("//table/tr").each do |tr|
        noc = ((t = tr.xpath("td[1]").text) == "") ? noc : t
        country = ((t = tr.xpath("td[2]").text) == "") ? country : t
        name = tr.xpath("td[3]").text
        url = tr.xpath("td[3]/a").attribute('href').value
        #http://www.isuresults.com/bios/isufs00010967.htm
        url =~ /isufs(\d+)\.htm$/
        isu_number = $1.to_i
        skater = {
          "isu_number" => isu_number,
          "name" => name,
          "bio" => "http://www.isuresults.com#{url}",
          "discipline" => discipline,
          "noc" => noc,
          "country" => country
        }
        skaters << skater
      end
      return skaters
    end
    def parse_skaters(disciplines = nil)
      disciplines_to_parse =
        if disciplines.nil?
          ['MEN', 'LADIES']
        elsif !disciplines.class.is_a?
          [disciplines]
        end
      disciplines_to_parse.map {|disc|
        parse_skaters_discipline(disc)
      }.flatten
    end
    ################
    # competition
    #
    def parse_competitions(max_page=nil)
      url = "http://figure2.me/slfs/competitions/index/sort:start_d/direction:desc"
      p = 1
      data = []
      while true 
        $stderr.puts "parsing #{url}..."
        doc = @agent.get(url).parser
        
        #binding.pry
        #doc.xpath("//table/tr")[1..-1].each do |elem| 
        doc.xpath("//table/tr")[1..-1].each do |elem|   ## DEBUG
          hash = {
            "cid" => elem.xpath("td[1]/a").attribute('href').value.sub(/.*\/(\d+)/, '\\1'),
            "name" => elem.xpath("td[1]").text.chompsp,
            "isu_hp" => elem.xpath("td[2]/a").attribute('href').value
          }
          ["type", "year", "noc", "city", "start_date", "end_date"].each_with_index do |key, i|
            hash[key] = elem.xpath("td[#{i+3}]").text.chompsp
          end
          data << hash
        end
        
        ## next
        break if max_page && p >= max_page
        break unless doc.xpath("//span[@class='next disabled']").empty?
        next_span = doc.xpath("//span[@class='next']")
        url = next_span.xpath("a").attribute('href').value
        p = p + 1
      end
      
      return data
    end
    ################
    # score
    #
    def parse_score(sid)
      url = "http://figure2.me/slfs/scores/view/#{sid}"
      $stderr.puts "parsing #{url}..."
      doc = @agent.get(url).parser
      
      ## tr/dl/dd
      ##     sid, competition, category, segment, skater
      ar = [:score_name, :competition_name, :discipline, :segment, :skater_name]
      hash = {:sid => sid}
      i = 0
      ar.each do |key|
        elem = doc.xpath("//dl/dd")[i]
        e = elem.xpath("a"); 
        str = (e.empty?) ? elem.inner_html : e.inner_html
        hash[key] = str.chompsp
        i = i+1
      end
      # sid
      bio = doc.xpath("//dl/dd[5]/a").attribute("href").value
      # http://figure2.me/slfs/players/view/12461
      bio =~ /^.*\/([\d]+)$/
      hash[:skater_isu_number] = $1
      
      ## tr/dl/table/tr/td/dt
      ##     date, skating_order, ranking, tss, tes ,pcs, deductions
      ar = [:date, :skating_order, :ranking, :tss, :tes, :pcs, :deductions]

      # binding.pry
      ar.each_with_index do |key, i|
        elem = doc.xpath("//dl/table/tr/td/dd")[i]
        hash[key] = elem.text.chompsp
      end

      ## tr/dl/dd
      ##     total_bv, pdf
      hash[:total_bv] = doc.xpath("//dl/table/tr/td[2]/dd")[0].inner_html.chompsp
      hash[:pdf] = doc.xpath("//dl/table/tr/td[2]/dd")[1].xpath("a").attribute('href').value
      
      ## div(@class="related")/tr/td

      hash[:elements] = []
      # binding.pry
      doc.xpath("//tr[@colspan=2]/td[1]//table/tr").each do |elem|
        num = elem.xpath("td")[0]
        next if num.nil?
        # ar = [:element, :bv, :goe, :judge_scores, :score]
        h = {}
        h[:executed_element] = elem.xpath("td")[1].inner_html.chompsp.sub(/^([^\s]+) *(.*)$/, '\\1')
        h[:info] = $2 if $2
        h[:bv] = elem.xpath("td")[2].inner_html.chompsp.sub(/^([\d\.]+) *(.*)$/, '\\1')
        h[:credit] = $2 if $2

        h[:goe] = elem.xpath("td")[3].inner_html.chompsp
        h[:judge_scores] = elem.xpath("td")[4].inner_html.chompsp.split(/ +/)
        h[:score_of_panels] = elem.xpath("td")[5].inner_html.chompsp
        hash[:elements] << h
      end

      ## components
      hash[:components] = {}
      ar = [:ss, :tr, :pe, :ch, :in]
      # binding.pry
      ar.each_with_index do |key, i|
        elem = doc.xpath("//tr[@colspan=2]/td[2]//table/tr")[i+1]
        
        hash[:components][key] = {}
        hash[:components][key][:judge_scores] = elem.xpath("td")[1].inner_html.split(" ")
        hash[:components][key][:score_of_panels] = elem.xpath("td")[2].inner_html
      end
      
      $stderr.puts "   parsed: #{hash[:skater]} at #{hash[:competition]}/#{hash[:discipline]}/#{hash[:segment]}"
      return hash
    end
  end ## class
end
