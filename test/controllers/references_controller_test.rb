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

# Reference controller tests not yet broken into single test files.
class ReferencesControllerTest < ActionController::TestCase
  setup do
    @reference = references(:cavanilles_icones)
  end

  test "should route to reference typeahead suggestions by citation" do
    assert_routing "/references/typeahead/on_citation",
                   controller: "references",
                   action: "typeahead_on_citation"
  end

  # test "should route to show a reference" do
  # assert_routing '/references/1',
  #                { controller: "references",
  #                action: "show",
  #                id: "1",
  #                tab: "tab_show_1"}
  # end

  test "should show reference" do
    @request.headers["Accept"] = "application/javascript"
    get(:show,
        params: { id: @reference, tab: "tab_show_1" },
        session: { username: "fred",
                   user_full_name: "Fred Jones",
                   groups: [:edit] })
    assert_response :success
  end
end
