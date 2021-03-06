# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Be sure to include AuthenticationSystem in Application Controller
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  layout false
end
