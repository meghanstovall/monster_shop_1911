class ReviewsController<ApplicationController

  def new
    @item = Item.find(params[:item_id])
  end

  def create
    create_review
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    update_process
  end

  def destroy
    review = Review.find(params[:id])
    destroy_process(review)
  end



  private

  def update_process
    review = Review.find(params[:id])
    review.update(review_params)
    redirect_to "/items/#{review.item.id}"
  end

  def destroy_process(review)
    item = review.item
    review.destroy
    redirect_to "/items/#{item.id}"
  end

  def review_params
    params.permit(:title,:content,:rating)
  end

  def field_empty?
    params = review_params
    params[:title].empty? || params[:content].empty? || params[:rating].empty?
  end

  def create_review
    create_review_1 if field_empty? == true
    create_review_2 if field_empty? == false
  end

  def create_review_1
    item = Item.find(params[:item_id])
    flash[:error] = "Please fill in all fields in order to create a review."
    redirect_to "/items/#{item.id}/reviews/new"
  end

  def create_review_2
    @item = Item.find(params[:item_id])
    create_review_2_process(item = @item)
  end

  def create_review_2_process(item)
    review = item.reviews.create(review_params)
    review_save(item) if review.save == true
    review_save_error if review.save == false
  end

  def review_save(item)
    flash[:success] = "Review successfully created"
    redirect_to "/items/#{item.id}"
  end

  def review_save_error
    flash[:error] = "Rating must be between 1 and 5"
    render :new
  end

end
