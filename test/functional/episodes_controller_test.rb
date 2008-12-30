require File.dirname(__FILE__) + '/../test_helper'
require 'episodes_controller'

# Re-raise errors caught by the controller.
class EpisodesController; def rescue_action(e) raise e end; end

class EpisodesControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
