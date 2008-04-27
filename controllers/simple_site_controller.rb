class SimpleSiteController < ApplicationController
  include SimpleSite::Root
  include Ddb::ControllerMethods
  
  class << self
    def model_name
      "simple_site"
    end
    
    def default_baseclass
      Ddb::Model
    end
  end
  
  def index
    @assigns['simple_site'] = model.find_all_like_path("index%").first
    @assigns['simple_sites'] = model.find(:all)
    add_simple_site_asssigns
    simple_site_render
  end
  
  def method_missing(action)
    entry = case
    when model.table_exists? 
      entries = model.find_all_like_path("#{action}%")
      case entries.length
      when 0 then model.new
      when 1 then entries.first
      else
        raise "more than one entry found for: #{action}"
      end
    else
      nil
    end

    @assigns['simple_site'] = entry
    super
  end
  
  def tutorial
    @simple_site = model.find_all_like_path("tutorial%").first
    @tutorials = Ddb.model('tutorial').find(:all)
    @__controller = self
  end
  
end