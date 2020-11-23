class PersonsController < ApplicationController
  before_action :set_person, only: [:show, :update, :destroy, :show_version]
    
  # GET /persons
  def index
    @persons = Person.all
    render json: @persons
  end

  # POST /persons
  def create
    @person = Person.new(person_params)
    if @person.save
      render json: @person, status: 201
    else
      render json: { errors: @person.errors }, status: 422
    end
  rescue ActionController::ParameterMissing => e
    render json: { error: e.to_s}, status: :unprocessable_entity
  end

  # GET /persons/:id
  def show
    @person = Person.find(params[:id])
    render json: @person
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }, status: :not_found
  end

  # GET /persons/:id/version/:version_id
  def show_version
    @version = PaperTrail::Version.find(params[:version_id])
    render json: { version: @version.reify }, status: 200

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }, status: :not_found
  end


  # GET /persons/:id/history
  def history
    @history = PaperTrail::Version.where(params[:id])

    render json: { history: @history }
  end

  # PUT /persons/:id
  def update
    if @person.update_attributes(person_params)
      render json: { person: @person }
    else
      render json: { errors: player.errors }, status: 500
    end
  end

  # DELETE /persons/:id
  def destroy
    if @person.destroy!
      render json: { person: @person }
    else
      render json: { errors: @person.errors }, status: 500
    end
  end

  private

  def person_params
    # whitelist params
    params.require(:person).permit(:first_name, :middle_name, :last_name, :email, :age)
  end

  def set_person
    @person = Person.find(params[:id])
  end
end
