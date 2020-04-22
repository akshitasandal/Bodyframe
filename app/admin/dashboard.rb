# Trestle.admin(:dashboard) do
#   menu do
#     item :dashboard, icon: "fa fa-tachometer"
#   end

#   controller do
#     def index
#       #@missing_warhead_count = Warhead.missing.count
#     end
#   end
# end

# # Trestle.resource(:users) do
# #   # Add a link to this admin in the main navigation
# #   menu do
# #     group :user_management, priority: :first do
# #       item :users, icon: "fa fa-file-text-o"
# #     end
# #   end

# #   # Define the form structure for the new & edit actions
# #   form do
# #     # Organize fields into tabs and sidebars
# #     tab :user do
# #       text_field :full_name

# #       # Define custom form fields for easy re-use
# #       editor :body
# #     end

# #     tab :metadata do
# #       # Layout fields based on a 12-column grid
# #       row do
# #         col(sm: 6) { select :full_name, User.all }
# #         col(sm: 6) { tag_select :tags }
# #       end
# #     end

# #     sidebar do
# #       # Render a custom partial: app/views/admin/posts/_sidebar.html.erb
# #       render "sidebar"
# #     end
# #   end
# # end