class Admin::SitesController< Admin::BaseController
  resource_controller
 
  create.before do
    @site.parent_id = @current_site.id
    current_user.roles << Role.create(:name => "admin_" + @site.name)
  end
 
  private
  def collection
    @collection ||= @site.self_and_children
  end
end
