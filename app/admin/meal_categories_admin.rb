Trestle.resource(:meal_categories) do
    menu do
      item :meal_categories, icon: "fa fa-cutlery"
    end
  
    #Customize the table columns shown on the index view.
    
    table do
      column :name
      actions do |toolbar, instance, admin|
        toolbar.edit if admin && admin.actions.include?(:edit)
        toolbar.delete if admin && admin.actions.include?(:destroy)
      end
    end
  
    controller do
      def index
        @dont_display_new_link = true
      end
    end
    
  end
    