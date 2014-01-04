class SlotsController < ApplicationController
  layout "slots"
  before_filter :authenticate_user!
  # GET /slots
  # GET /slots.json
  def index
    @semester = Semester.where(month: params[:month], year: params[:year])[0]
    @semester ||= Semester.current_semester
    @slots = @semester.slots.order(:start).group_by(&:weekday)
    (0..6).each {|i| @slots[i] ||= [] }

    @slot = Slot.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @slots }
    end
  end

  # GET /slots/1
  # GET /slots/1.json

  # GET /slots/new
  # GET /slots/new.json
  def new
    @slot = Slot.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @slot }
    end
  end

  # GET /slots/1/edit
  def edit
    @slot = Slot.find(params[:id])
  end

  # POST /slots
  # POST /slots.json
  def create
    showID = params[:slot].delete(:show)
    name = params[:slot].delete(:name)
    dj = params[:slot].delete(:dj)
    @semester = Semester.find(params[:slot].delete(:semester_id))
    if showID
      @show = Show.find(showID)
    else
      @show = Show.new(:name => name, :dj => dj)
    end
    @slot = Slot.new(params[:slot])
    @show.slots << @slot
    @semester.slots << @slot

    respond_to do |format|
      if @slot.save
        format.html { redirect_to :slots, notice: 'Slot was successfully created.' }
        format.json { render json: @slot, status: :created, location: @slot }
      else
        format.html { render action: "new" }
        format.json { render json: @slot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /slots/1
  # PUT /slots/1.json
  def update
    @slot = Slot.find(params[:id])

    respond_to do |format|
      if @slot.update_attributes(params[:slot])
        format.html { redirect_to @slot, notice: 'Slot was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @slot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slots/1
  # DELETE /slots/1.json
  def destroy
    @slot = Slot.find(params[:id])
    @slot.destroy

    respond_to do |format|
      format.html { redirect_to slots_url }
      format.json { head :no_content }
    end
  end
end
