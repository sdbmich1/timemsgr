class PicturesController < ApplicationController
  
  def asset
    instance = Picture.find(params[:id])
    params[:style].gsub!(/\.\./, '')
    #check permissions before delivering asset?
    send_file instance.photo.path(params[:style].intern),
              :type => instance.photo_content_type,
              :disposition => 'inline'
  end
end
