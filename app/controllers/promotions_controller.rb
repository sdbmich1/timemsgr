class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(params[:promotion])
    if @promotion.save
      redirect_to @promotion, :notice => "Successfully created promotion."
    else
      render :action => 'new'
    end
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(params[:promotion])
      redirect_to @promotion, :notice  => "Successfully updated promotion."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy
    redirect_to promotions_url, :notice => "Successfully destroyed promotion."
  end
end
