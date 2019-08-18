
module NessusClient::Scans

  def list_scans( folder_id=nil )
    query = folder_id.nil? ? nil : { "folder_id" => folder_id }
    self.request.get( "/scans", nil, query )
  end
  alias_method :scans, :list_scans 

  def scan_details( scan_id, history_id=nil )
    query = history_id.nil? ? nil : { "history_id" => history_id }
    self.request.get( "/scans/#{scan_id}", nil, query )
  end

  def launch_by_name( scan_name, targets=[] )
    scan_id = get_scan_by_name( scan_name )
    params = { :alt_targets => targets } unless targets.empty?
    self.request.post( "/scans/#{scan_id}/launch", params )
  end

  def get_scan_by_name( folder_id=nil, name )
    Oj.load(list_scans( folder_id ))["scans"].each do |scan|
      return scan['id'] if scan['name'] == name
    end
  end
  
end