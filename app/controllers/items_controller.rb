class ItemsController < ApplicationController
  layout 'slots'
  before_filter :authenticate_user!
  # GET /items
  # GET /items.json
  def index
    @active_items = Item.select(&:active?).sort_by(&:name)
    @inactive_items = Item.select(&:inactive?).sort_by(&:name)

    @item = Item.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])
    @requested = @item.rewards.select { |r| !r.premia_sent }.sort_by { |r| r.pledger.name }
    @fulfilled = @item.rewards.select { |r| r.premia_sent }.sort_by { |r| r.pledger.name }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
      format.csv {
        @pledgers = @requested.map(&:pledger).group_by(&:name).map{ |x,y| [y.first, y.count] }
        headers['Content-Disposition'] = "attachment; filename=\"#{@item.name} Requests\""
        headers['Content-Type'] ||= 'text/csv'
      }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to :items, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @slot }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { respond_with_bip(@item) }
      else
        format.html { render action: 'edit' }
        format.json { respond_with_bip(@item) }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end
end
