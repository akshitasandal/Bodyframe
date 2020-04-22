Trestle.resource(:faqs) do
  menu do
    item :faqs, icon: "fa fa-question-circle"
  end

  #Customize the table columns shown on the index view.
  table do
    column :question
    column :answer
    actions do |toolbar, instance, admin|
      toolbar.edit if admin && admin.actions.include?(:edit)
      toolbar.delete if admin && admin.actions.include?(:destroy)
    end
  end

  # controller do
  #   def index
  #     @faqs = Faq.select(:question, :answer)
  #   end
  # end

  form do |faq|
    row do
      col(xs: 12) { text_field :question }
    end
    row do
      col(xs: 12) { text_area :answer }
    end
  end
end
  