module RelationshipsHelper
  
  def get_trk_list(trkr, trkd)
    trkr | trkd if trkd
  end
  
  def getMethod(usr, trkr)
    get_status(usr, trkr) == 'Pending' ? 'put' : get_status(usr, trkr) == 'Accepted' ? 'delete' : 'post'
  end
  
  def getConfirmMsg(usr, trkr)
    get_status(usr, trkr) == 'Pending' ? 'Accept this connection request?' : get_status(usr, trkr) == 'Accepted' ? 'Delete this connection?' : 'Send connection request to this user?'
  end
  
  def getLinkTag usr, trkr
    get_status(usr, trkr) == 'Pending' ? 'Accept' : get_status(usr, trkr) == 'Accepted' ? 'Delete' : 'Add'    
  end  
end
