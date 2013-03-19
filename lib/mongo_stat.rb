require 'mongo'
require 'active_support/core_ext'

module MongoStat
  class MongoStat

    attr_accessor :stats
    attr_accessor :collection
    attr_accessor :mongo_host
    attr_accessor :mongo_db
    

    def initialize(host, db, collection)
      self.collection = collection
      self.mongo_host = host
      self.mongo_db = db
      self.stats = {}
      self.stats[self.collection] = Hash.new(0)
    end

    def log(stat, increment_value = 1)
      self.stats[self.collection][stat] += increment_value
    end

    def save()
      mdb = Mongo::MongoClient.new(self.mongo_host).db(self.mongo_db)
      stat_coll = mdb.collection(self.collection)
      stat_coll.find({'date' => Time.now.to_date.to_time}).first
      stat_coll.update({'date' => Time.now.to_date.to_time}, {'$inc' => self.stats[collection]}, {:upsert => true})
      mdb.connection.close
      puts "Stats logged: #{self.stats[self.collection]}" if $DEBUG_MODE == true
      self.stats[self.collection] = Hash.new(0)
    end

  end
  
  class LogTimes

    attr_accessor :stats
    attr_accessor :log_counters
    attr_accessor :collection
    attr_accessor :log_timers

    def initialize(collection)
      self.collection = collection
      self.stats = {}
      self.stats[self.collection] = Hash.new(0.0)
      self.log_counters = {}
      self.log_counters[self.collection] = Hash.new(0)
      self.log_timers = {}
      self.log_timers[self.collection] = Hash.new {|h, v| h[v] = Time.now.to_f}
    end

    def log(stat, increment_value = 1)
      self.stats[self.collection][stat] += increment_value
      self.log_counters[self.collection][stat] += 1
    end

    def log_start(stat)
      self.log_timers[self.collection][stat]
    end

    def log_end(stat)
      self.stats[self.collection][stat] += Time.now.to_f - self.log_timers[self.collection][stat]
      self.log_timers[self.collection].delete(stat)
      self.log_counters[self.collection][stat] += 1
    end

    def reset(stat)
      self.stats[self.collection][stat] = 0.0
      self.log_timers[self.collection].delete(stat) rescue nil
      self.log_counters[self.collection][stat] = 0
    end

    def reset_timer(stat)
      self.log_timers[self.collection].delete(stat) rescue nil
    end


    def reset_all_timers
      self.log_timers[self.collection] = Hash.new {|h, v| h[v] = Time.now.to_f}
    end

    def get_totals()
      return self.stats[self.collection]
    end

    def get_counters()
      return self.log_counters[self.collection]
    end

    def get_averages()
      avgs = {}
      self.stats[self.collection].each {|stat, value|
        avgs[stat] = value / self.log_counters[self.collection][stat] rescue 0
      }
      avgs
    end


  end
  
end