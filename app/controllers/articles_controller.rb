# frozen_string_literal: true

class ArticlesController < ApplicationController
  include Pagy::Backend

  before_action :set_article, only: %i[edit update show destroy]
  # before_action :require_user, except: %i[index show]
  # before_action :require_same_user, only: %i[edit update destroy]

  def index
    @pagy, @articles = pagy(Article.all, items: 3)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = 'Article was successfully created'
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def show; end

  def update
    if @article.update(article_params)
      flash[:success] = 'Article was updated'
      redirect_to article_path(@article)
    else
      flash[:success] = 'Article was not updated'
      render 'edit'
    end
  end

  def edit; end

  def destroy
    @article.destroy
    flash[:success] = 'Article was deleted'
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, :user_id, category_ids:[])
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def require_same_user
    if current_user != @article.user
      flash[:danger] = 'You can only edit or delete your own articles'
      redirect_to root_path
    end
  end
end
