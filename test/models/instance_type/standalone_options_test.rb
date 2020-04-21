# frozen_string_literal: true


#   Copyright 2015 Australian National Botanic Gardens
#
#   This file is part of the NSL Editor.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
require "test_helper"

# Instance type options test.
class InstanceTypeStandaloneOptionsTest < ActiveSupport::TestCase
  setup do
    options = InstanceType.standalone_options
    assert options.class == Array, "Should be an array."
    assert_equal 10, options.size, "Should be 10 of them."
    @names = options.collect(&:first)
    @expected = %w[autonym comb.\ et\ stat.\ nov. comb.\ nov. explicit\ autonym explicit\ autonym implicit\ autonym nom.\ et\ stat.\ nov. nom.\ nov. primary\ reference secondary\ reference tax.\ nov.]
  end

  test "instance type standalone options" do
    @expected.each do |expected|
      assert @names.include?(expected),
             "Synonym type options should include #{expected}"
    end
    @names.each do |name|
      assert @expected.include?(name),
             "#{name} is unexpected as a synonym type option"
    end
  end
end