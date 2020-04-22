class Web::FaqsController < ActionController::Base
    def index
      @faqs = Faq.all
    end
  end