class ShowsController < ApplicationController
  before_filter :authenticate_user!
  # GET /shows
  # GET /shows.json
  def index
    @semester = Semester.where(month: params[:month], year: params[:year])[0]
    @semester ||= Semester.current_semester
    # @shows = Show.where("name != 'ALL FREEFORM'").includes(:slots).select{ |s| s.slots.collect{ |e| e.semester }.include? @semester.to_f }
    @slots = @semester.slots.to_a.uniq { |s| s.show_id }.reject { |s| s.show.get_name == 'ALL FREEFORM' }
    @shows = @slots.map { |x| [x.show, x.show.slots.where(semester_id: @semester.id).reduce(0) { |sum, e| sum + e.donations.reject{|d| d.pledger.underwriting}.map { |d| d.amount }.reduce(:+).to_f }] }
    @shows = @shows.sort_by { |x| x[1] }.reverse_each
    @first_place_total = @shows.first[1]
    @shows = @shows.map { |x| x + [100 * x[1] / @first_place_total] }

    # TODO Normalize index by time on air?

    # @shows: [ <Show>object, total, percent_of_first_place ]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shows }
    end
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @show = Show.find(params[:id])
    @slots = (@show.slots).sort_by { |s| s.semester }.reverse[0..3].reverse
    @slots = @slots.map do |s| [s,
                                s.donations.map { |d| d.amount }.reduce(:+).to_f,
                                s.donations.sort_by { |x| x.amount }.reverse]end
    @comments = @show.comments.sort_by { |c| c.created_at }.reverse

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/new
  # GET /shows/new.json
  def new
    @show = Show.new

    respond_to do |format|
      format.html { render layout: !request.xhr? }
      format.json { render json: @show }
    end
  end

  # GET /shows/1/edit
  def edit
    @show = Show.find(params[:id])
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(params[:show])

    respond_to do |format|
      if @show.save
        format.html { redirect_to @show, notice: 'Show was successfully created.' }
        format.json { render json: @show, status: :created, location: @show }
      else
        format.html { render action: 'new' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shows/1
  # PUT /shows/1.json
  def update
    @show = Show.find(params[:id])

    respond_to do |format|
      if @show.update_attributes(params[:show])
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end
end
