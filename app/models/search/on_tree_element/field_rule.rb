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
class Search::OnTreeElement::FieldRule
  RULES = {
    "id:"                 => { where_clause: "id = ? ",
                               order: "id"},
    "simple_name:"         => { trailing_wildcard: true,
                              where_clause: " lower(simple_name) like ?",
                                      order: "1"},
    "changes-for-version:"      => { where_clause: " id in ( SELECT tree_element_id FROM tree_version_element WHERE tree_version_id = ? EXCEPT SELECT tree_element_id FROM tree_version_element WHERE tree_version_id = (select previous_version_id from tree_version where id = ?)) ",
                             order: "id"},
    "changes:"      => { where_clause: 
 "id in (
    SELECT tree_element_id
      FROM tree_version_element
    WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[1])::integer
    EXCEPT
    SELECT tree_element_id
      FROM tree_version_element
    WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[2])::integer
       ) ",
                             order: "simple_name"},
    "changes-between-2-versions:"   => {
                               where_clause: " id in (
select id from tree_element
where previous_element_id is null
  and id in
(
SELECT tree_element_id
   FROM tree_version_element
   WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[1])::integer
  EXCEPT
  SELECT tree_element_id
   FROM tree_version_element
   WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[2])::integer
)
union
select id from tree_element
where previous_element_id is null
  and id in
(
SELECT tree_element_id
   FROM tree_version_element
   WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[2])::integer
  EXCEPT
  SELECT tree_element_id
   FROM tree_version_element
   WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[1])::integer 
)
union
select id from tree_element
where previous_element_id is not null
  and id in
(
SELECT tree_element_id
   FROM tree_version_element
   WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[1])::integer 
  EXCEPT
  SELECT tree_element_id
   FROM tree_version_element
   WHERE tree_version_id = ((regexp_split_to_array(?, '[^0-9][^0-9]*'))[2])::integer
)
)", order: "simple_name"},
    "for-tree-id:"      => { where_clause: " tree_id = ?",
                             order: "created_at desc"},
  }.freeze
end


