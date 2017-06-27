class PartiesController < ApplicationController
  def index
    @parties = Array.new

    if !params[:sort].blank?
      order = "#{params[:sort]} #{(params[:asc].blank? || params[:asc] == 'true') ? 'DESC' : 'ASC'}"
      Party.order(order).all.each do |party|
        @parties << party
      end
    else
      order = "when #{(params[:asc].blank? || params[:asc] == 'true') ? 'DESC' : 'ASC'}"
      @parties = Party.order(order).all
    end
  end

  def new
    @party = Party.new
    # so the view shows 0 and not blank
    @party.numgsts = 0
  end

  def create
    @party = Party.new
    params[:party][:numgsts] = 0 if params[:party][:numgsts].blank?

    # if end is blank, set to end of day
    params[:party][:when_its_over] = params[:party][:when].end_of_day if params[:party][:when_its_over].blank?
    @party.assign_attributes = params[:party]

    if @party.save
      @party.after_save
      redirect_to parties_url
    else
      flash[:notice] = "Party was incorrect."
      redirect_to new_party_url
    end
  end
end
