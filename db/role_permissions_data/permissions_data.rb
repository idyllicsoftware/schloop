admin_roles_maps = ["Product-Admin","school-Admin"]
user_roles_maps = ["Teacher","Parent"]

PERMISSIONS = [
{  
	:controller => "admin/schools", :action => "index", :flags => {}, :role_maps => ["Product-Admin"]
},
{  
	:controller => "admin/schools", :action => "new", :flags => {}, :role_maps => ["Product-Admin"]
}
]