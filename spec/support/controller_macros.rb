module ControllerMacros
  def login_school_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @school_admin = FactoryGirl.create(:user, :school_admin)
      FactoryGirl.create(:user_role, :school_admin, entity_id: @school_admin)
      sign_in @school_admin
    end
  end

  def login_product_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @product_admin = FactoryGirl.create(:user, :product_admin)
      FactoryGirl.create(:user_role, :product_admin, entity_id: @product_admin.id)
      sign_in @product_admin
    end
  end

  def login_teacher
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:teacher]
      @teacher = FactoryGirl.create(:teacher)
      FactoryGirl.create(:user_role, :teacher, entity_id: @teacher.id)
      sign_in @teacher
    end
  end

  def login_parent
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @parent = FactoryGirl.create(:parent)
      FactoryGirl.create(:user_role, :parent, entity_id: @parent.id)

      sign_in @parent
    end
  end
end
