module RelationshipsHelper
  
  def get_trk_list(trkr, trkd)
    trkr | trkd if trkd
  end
end
