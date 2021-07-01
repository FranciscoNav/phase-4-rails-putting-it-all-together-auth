class RecipesController < ApplicationController
    
    def index
        # byebug
        # user = User.find_by(params[:id])
        # if user.id == session[:user_id] 
        #     render json: user.recipes
        # end
        return render json: { errors: ["unauthorized"] }, status: :unauthorized unless session.include? :user_id
        recipes = Recipe.all
        render json: recipes, include: :user
    end

    def create
        # byebug
        return render json: { errors: ["unauthorized"] }, status: :unauthorized unless session.include? :user_id
        
        
        user = User.find_by(params[:id])
        recipe = user.recipes.create(recipe_params)
        if recipe.valid?
            render json: recipe, include: :user, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

end
