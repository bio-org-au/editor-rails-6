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

# Single name model scope test.
class ForNothovarietasTest < ActiveSupport::TestCase
  setup do
    rank_id = name_ranks(:nothovarietas).id
    @ranks = Name.from_a_higher_rank(rank_id).collect do |name|
      name.name_rank.name
    end.uniq
  end

  test "from a higher rank for nothovarietas" do
    asserts1
    asserts2
    asserts3
    asserts4
    asserts5
  end

  def asserts1
    assert @ranks.include?("Regnum"), "Should include Regnum"
    assert @ranks.include?("Division"), "Should include Division"
    assert @ranks.include?("Classis"), "Should include Classis"
    assert @ranks.include?("Subclassis"), "Should include Subclassis"
    assert @ranks.include?("Superordo"), "Should include Superordo"
  end

  def asserts2
    assert @ranks.include?("Ordo"), "Should include Ordo"
    assert @ranks.include?("Subordo"), "Should include Subordo"
    assert @ranks.include?("Ordo"), "Should include Ordo"
    assert @ranks.include?("Subordo"), "Should include Subordo"
    assert @ranks.include?("Familia"), "Should include Familia"
  end

  def asserts3
    assert @ranks.include?("Subfamilia"), "Should include Subfamilia"
    assert @ranks.include?("Tribus"), "Should include Tribus"
    assert @ranks.include?("Subtribus"), "Should include Subtribus"
    assert @ranks.include?("Genus"), "Should include Genus"
    assert @ranks.include?("Subgenus"), "Should include Subgenus"
  end

  def asserts4
    assert @ranks.include?("Sectio"), "Should include Sectio"
    assert @ranks.include?("Subsectio"), "Should include Subsectio"
    assert @ranks.include?("Series"), "Should include Series"
    assert @ranks.include?("Subseries"), "Should include Subseries"
    assert @ranks.include?("Superspecies"), "Should include Superspecies"
  end

  def asserts5
    assert @ranks.include?("Species"), "Should include Species"
    assert @ranks.include?("Subspecies"), "Should include Subspecies"
    assert_equal 20, @ranks.size
  end
end
