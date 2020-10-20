class CategoriesController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @categories = pagy(Category.all, items: 5)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Category was created successfully'
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category name was successfully updated'
      redirect_to category_path(@category)
    else
      render 'edit'
    end
  end

  def show
    @category = Category.find(params[:id])
    @pagy, @category_articles = pagy(Category.articles, items: 5)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
