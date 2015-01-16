class SemestersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_semester, only: [:show, :edit, :update, :destroy]

  # GET /semesters
  def index
    @semesters = Semester.all.includes(:slots).reverse
    @revenue = {}
    @semesters.each do |s|
      donations = s.slots.reduce([]) { |a, e| a + e.donations }
        .reject{ |d| d.pledger.underwriting }
      paid_donations = donations.select { |d| d.payment_received == true }
      @revenue[s] = paid_donations.reduce(0) { |a, e| a + e.amount }
    end
    @semester = Semester.new
  end

  # GET /semesters/new
  def new
    @semester = Semester.new
  end

  # POST /semesters
  def create
    @semester = Semester.new(semester_params)

    if @semester.save
      redirect_to controller: :slots, action: 'index', month: @semester.month,
        year: @semester.year, notice: 'Semester was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /semesters/1
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to @semester, notice: 'Semester was successfully updated.' }
        format.json { respond_with_bip(@semester) }
      else
        format.html { render action: 'edit' }
        format.json { respond_with_bip(@semester) }
      end
    end
  end

  # DELETE /semesters/1
  def destroy
    @semester.destroy
    redirect_to semesters_url, notice: 'Semester was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_semester
      @semester = Semester.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def semester_params
      params[:semester]
    end
end
