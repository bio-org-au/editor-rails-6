class SearchController < ApplicationController
  before_action :hide_details

  def search
    handle_old
    run_local_search || run_empty_search
    respond_to do |format|
      format.html
      format.csv do
        data = @search.executed_query.results.to_csv
        begin
          data = data.unicode_normalize(:nfc).encode("UTF-16LE")
          data = "\xFF\xFE".dup.force_encoding("UTF-16LE") + data
        rescue => encoding_error
          logger.error(encoding_error.to_s)
          logger.error("This CSV error in the SearchController does not")
          logger.error("prevent CSV data being created but it does indicate")
          logger.error("failure to encode the CSV as UTF-16LE")
        end
        send_data data
      end
    end
  rescue ActiveRecord::StatementInvalid => e
    params[:error_message] = "That query did not work. Please check the \
    search directives and arguments."
    logger.error("Search error: #{e}")
    @search = Search::Error.new(params) unless @search.present?
  rescue => e
    params[:error_message] = e.to_s
    @search = Search::Error.new(params) unless @search.present?
  end

  def set_include_common_and_cultivar
    session[:include_common_and_cultivar] = \
      !session[:include_common_and_cultivar]
  end

  def extras
    mapper = Search::Mapper::Extras.new(params)
    logger.debug(mapper.partial)
    render partial: mapper.partial
  end

  def reports
  end

  private

  def trim_session_searches
    session[:searches].shift if session[:searches].size > 2
  end

  def run_local_search
    return false unless params[:query_string].present?
    @focus_id = params[:focus_id]
    params[:current_user] = current_user
    params[:include_common_and_cultivar_session] = \
      session[:include_common_and_cultivar]
    # Avoid "A copy of Search has been removed from the module tree but is still active" error
    # https://stackoverflow.com/questions/29636334/a-copy-of-xxx-has-been-removed-from-the-module-tree-but-is-still-active
    @search = ::Search::Base.new(params)
    true
  end

  def run_empty_search
    if @taxonomic_review_mode 
      params["target"] = 'Trees'
    else
      params["target"] = 'Names'
    end
    @empty_search = true
    @search = Search::Empty.new(params)
  end

  def set_tree_defaults
    params[:query_field] = "apc" if params[:query_field].blank?
    params[:query] = plantae_haeckel if params[:query].blank?
  end

  def plantae_haeckel
    Name.find_by(full_name: "Plantae Haeckel").id
  end

  # note: services needs to be changed to use the "new" params
  # before you can remove this code
  def handle_old
    handle_old_style_params
    handle_names_plus_instances_target
  end

  # translate services/search/link
  def handle_old_style_params
    return unless params[:query].present?
    unless params[:query_field] == "name-instances"
      raise "Cannot handle this query-field: #{params[:query_field]}"
    end
    params[:query_target] = "name"
    params[:query_string] = params[:query].sub(/\z/, " show-instances:")
  end

  def handle_names_plus_instances_target
    return unless params[:query_target].present?
    return unless params[:query_target] =~ /Names plus instances/i
    params[:query_target] = "name"
    return if params[:query_string] =~ /show-instances:/
    params[:query_string] = params[:query_string].sub(/\z/, " show-instances:")
  end
end

