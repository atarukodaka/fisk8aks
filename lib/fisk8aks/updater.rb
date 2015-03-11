# -*- coding: utf-8 -*-

require './models/skater'
require './models/competition'
require './models/score'
require './models/element'
require './models/component'

module Fisk8aks
  class Updater
    def update_record(table_class, hash, id_key)
      record = table_class.where(id_key => hash[id_key]).first || table_class.create
      
      keys_to_update = table_class.columns.map(&:name).reject {|item| item == "id"}
      keys_to_update.each do |key|
        value = hash[key]
        record[key] = value if ! value.nil?
      end
      record.save
      return record
    end

    ###
    def update_skater(hash)
      update_record(Skater, hash, 'isu_number')
    end
    def update_competition(hash)
      update_record(Competition, hash, 'cid')
    end
    def update_score(hash)
      # competition_name => competition record
      # skater_isu_number => skater record
      # skater_name
      # elements, components
      #binding.pry
      score_record = update_record(Score, hash, 'sid')
      
      ## elements
      hash['elements'].each_with_index do |element, i|
        number = i+1
        element_record = Element.where(score_id: score_record.id, number: number).first || Element.create

        hash_to_update = {
          "number" => number,
          "judge_scores" => element['judge_scores'].join(" ")
        }
        ['executed_element', 'bv', 'goe', 'score_of_panels'].each do |key|  # info, credit TODO
          hash_to_update[key] = element[key]
        end
        element_record.attributes = hash_to_update
        element_record.save
        score_record.elements << element_record
      end
      ## components
      hash['components'].each do |name, component|
        component_record = Component.where(score_id: score_record.id, name: name).first || Component.create

        hash_to_update = {
          "name" => name,
          "judge_scores" => component['judge_scores'].join(" ")
        }
        ['factor', 'score_of_panels'].each do |key|   # TODO factor
          hash_to_update[key] = component[key]
        end
        component_record.attributes = hash_to_update
        component_record.save
        score_record.components << component_record
      end
      score_record.save
      ## skater association
      if skater = Skater.where(isu_number: hash['skater_isu_number']).first
        skater.scores << score_record
      end
      ## competition association
      if competition = Competition.where(name: hash['competition_name']).first
        competition.scores << score_record
      end
    end
  end  ## class
end

