# -*- coding: utf-8 -*-

module Fisk8aks
  class Updater
    def update_record(table_class, hash, id_key, opt={})
      record = table_class.where(id_key => hash[id_key]).first
      if opt[:skip_if_exists] && record
        return record
      else
        record = table_class.create
      end
      
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
  end  ## class
end

