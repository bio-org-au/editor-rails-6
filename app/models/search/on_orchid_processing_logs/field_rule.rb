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
class Search::OnOrchidProcessingLogs::FieldRule
  RULES = {
    "latest:"              => { where_clause: "1=1",
                                order: "logged_at desc"},
    "log-entry:"              => { leading_wildcard: true,
                                   trailing_wildcard: true,
                                   where_clause: "lower(log_entry) like ?",
                                   order: "logged_at desc" },
  }.freeze
end
