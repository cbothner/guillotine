class PledgersController < ApplicationController
  # GET /pledgers
  # GET /pledgers.json
  def index
    @pledgers = Pledger.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pledgers }
    end
  end

  # GET /pledgers/search.json?name=name
  def search
    #@pledgers = Pledger.find_by_sql[" SELECT name, 
                                        #perm_address, 
                                        #similarity(name, ?) AS sml
                                      #FROM pledgers
                                      #WHERE name % ?
                                      #ORDER BY sml DESC, name", params[:name], params[:name]]
    @pledgers = Pledger.select_with_args("id, name, perm_address, similarity(name, ?) AS sml", params[:name]).where("name % ?", params[:name]).order("sml DESC,name")
    respond_to do |format|
      format.json { render json: @pledgers }
    end
  end

  # GET /pledgers/1
  # GET /pledgers/1.json
  def show
    @pledger = Pledger.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pledger }
    end
  end

  # GET /pledgers/new
  # GET /pledgers/new.json
  def new
    @pledger = Pledger.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pledger }
    end
  end

  # GET /pledgers/1/edit
  def edit
    @pledger = Pledger.find(params[:id])
  end

  # POST /pledgers
  # POST /pledgers.json
  def create
    @pledger = Pledger.new(params[:pledger])

    respond_to do |format|
      if @pledger.save
        format.html { redirect_to @pledger, notice: 'Pledger was successfully created.' }
        format.json { render json: @pledger, status: :created, location: @pledger }
      else
        format.html { render action: "new" }
        format.json { render json: @pledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pledgers/1
  # PUT /pledgers/1.json
  def update
    @pledger = Pledger.find(params[:id])

    respond_to do |format|
      if @pledger.update_attributes(params[:pledger])
        format.html { redirect_to @pledger, notice: 'Pledger was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pledgers/1
  # DELETE /pledgers/1.json
  def destroy
    @pledger = Pledger.find(params[:id])
    @pledger.destroy

    respond_to do |format|
      format.html { redirect_to pledgers_url }
      format.json { head :no_content }
    end
  end
end