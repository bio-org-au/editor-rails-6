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

#  Name services
class Orchid::AsInstanceCreator
  def initialize(orchid, reference, authorising_user)
    announce "Instance Creator for orchid: #{orchid.taxon} (#{orchid.record_type})"
    announce "Authorising user: #{authorising_user}"
    @orchid = orchid
    @ref = reference
    @authorising_user = authorising_user
  end

  def create_instance_for_preferred_matches
    debug("Orchid::AsInstanceCreator#create_instance_for_preferred_matches")
    records = 0
    return 0 if stop_everything?
    @orchid.preferred_match.each do |preferred_match|
      debug(preferred_match.class)
      if preferred_match.standalone_instance_created
      elsif preferred_match.standalone_instance_found
      else
        log_to_table("Create instance for orchid #{@orchid.taxon}", @authorising_user)
        records += preferred_match.create_instance(@ref, @authorising_user)
      end
    end
    records
  end

  def log_to_table(entry, user)
    OrchidProcessingLog.log(entry, user)
  rescue => e
    Rails.logger.error("Couldn't log to table: #{e.to_s}")
  end

  def stop_everything?
    if @orchid.exclude_from_further_processing?
      return true
    elsif @orchid.parent.try('exclude_from_further_processing?')
      return true
    elsif @orchid.hybrid_cross?
      debug("stop_everything?  Orchid is a hybrid cross - not going to process these.")
      return true
    end
    false
  end

  def taxon
    @orchid.taxon
  end

  def record_failure(msg)
    msg.sub!(/uncaught throw /,'')
    msg.gsub!(/"/,'')
    msg.sub!(/^Failing/,'')
    debug "record_failure Failure: #{msg}"
  end

  def announce(msg)
    debug "="*(msg.length)
    debug msg
    debug "="*(msg.length)
  end

  def debug(msg)
    Rails.logger.debug("Orchid##{msg}")
  end
end
