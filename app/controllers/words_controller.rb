class WordsController < ApplicationController
  caches_page :home
  # GET /words
  # GET /words.json
  def index
    authorize! :manage,Word
    @words = Word.page(params[:page] || 1).per(100)
    @words = @words.where(:isbrand=>true) if params.has_key? :isbrand
    @words = @words.where(:publish=>eval(params[:publish])) if params.has_key? :publish

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @words }
    end
  end

  # GET /words/1
  # GET /words/1.json
  def show
    @word = Word.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @word }
    end
  end
  def home
    @slug = params.has_key?(:id) ? params[:id] : request.subdomain
    @word = Word.find_by_slug @slug
    #@rands = Word.short.random.limit(10)
    @rands = Word.random(10).short
    @relates = @word.related
  end
  def flush
    @word = Word.find_by_slug request.subdomain
    expire_page :action=>:home
    redirect_to :action=>:home
  end

  # GET /words/new
  # GET /words/new.json
  def new
    @word = Word.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @word }
    end
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(params[:word])

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render json: @word, status: :created, location: @word }
      else
        format.html { render action: "new" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /words/1
  # PUT /words/1.json
  def update
    @word = Word.find(params[:id])

    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    respond_to do |format|
      format.html { redirect_to words_url }
      format.json { head :no_content }
    end
  end
end
