# frozen_string_literal: true
require 'test_helper'

class Europeana::LoggingTest < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, Europeana::Logging
  end
end
