Fisk8aks::Admin.controllers :elements do
  get :index do
    @title = "Elements"
    @elements = Element.all
    render 'elements/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'element')
    @element = Element.new
    render 'elements/new'
  end

  post :create do
    @element = Element.new(params[:element])
    if @element.save
      @title = pat(:create_title, :model => "element #{@element.id}")
      flash[:success] = pat(:create_success, :model => 'Element')
      params[:save_and_continue] ? redirect(url(:elements, :index)) : redirect(url(:elements, :edit, :id => @element.id))
    else
      @title = pat(:create_title, :model => 'element')
      flash.now[:error] = pat(:create_error, :model => 'element')
      render 'elements/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "element #{params[:id]}")
    @element = Element.find(params[:id])
    if @element
      render 'elements/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'element', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "element #{params[:id]}")
    @element = Element.find(params[:id])
    if @element
      if @element.update_attributes(params[:element])
        flash[:success] = pat(:update_success, :model => 'Element', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:elements, :index)) :
          redirect(url(:elements, :edit, :id => @element.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'element')
        render 'elements/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'element', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Elements"
    element = Element.find(params[:id])
    if element
      if element.destroy
        flash[:success] = pat(:delete_success, :model => 'Element', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'element')
      end
      redirect url(:elements, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'element', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Elements"
    unless params[:element_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'element')
      redirect(url(:elements, :index))
    end
    ids = params[:element_ids].split(',').map(&:strip)
    elements = Element.find(ids)
    
    if Element.destroy elements
    
      flash[:success] = pat(:destroy_many_success, :model => 'Elements', :ids => "#{ids.to_sentence}")
    end
    redirect url(:elements, :index)
  end
end
