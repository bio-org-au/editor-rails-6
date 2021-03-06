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

# Single controller test.
class AuthorEditMarkAsDuplicateOfTwoMatchesTest < ActionController::TestCase
  tests AuthorsController

  test "update author to be duplicate of one of two matches" do
    @request.headers["Accept"] = "application/javascript"
    author = authors(:hesp_1)
    intended_dupe = authors(:hesp_3)
    patch(:update,
          params: { id: intended_dupe.id,
                    author: { "name" => "Hesp",
                              "duplicate_of_typeahead" => "Hesp",
                              "duplicate_of_id" => author }, },
          session: { username: "fred",
                     user_full_name: "Fred Jones",
                     groups: ["edit"] })
    assert_response :success
    expected_dupe = Author.find(intended_dupe.id)
    assert_equal author.id, expected_dupe.duplicate_of_id, "Should be equal."
  end
end
