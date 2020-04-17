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
class DuplicateInstanceNotAllowedTest < ActionController::TestCase
  tests InstancesController
  def setup
    @base = instances(:casuarina_inophloia_by_mueller)
    assert_equal(@base.instance_type_id,
                 instance_types(:secondary_reference).id,
                 "Target instance should be a secondary reference.")
    @instance_params = { "instance_type_id" => @base.instance_type_id,
                         "page" => @base.page,
                         "name_id" => @base.name_id,
                         "reference_id" => @base.reference_id,
                         "multiple_primary_override" => "0" }
    @request.headers["Accept"] = "application/javascript"
  end

  test "cannot create duplicate instance" do
    assert_no_difference("Instance.count") do
      post(:create,
           params: { instance: @instance_params },
           session: { username: "fred",
                      user_full_name: "Fred Jones",
                      groups: ["edit"] })
    end
    check_assertions
  end

  def check_assertions
    assert_response 422, "Response should be 422, unprocessable entity."
    es = "already exists with the same reference, type and page."
    assert_match(/#{es}/,
                 response.body,
                 "Expected error message did not appear")
  end
end
