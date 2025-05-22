module VisitTracker
  extend ActiveSupport::Concern

  included do
    before_action :track_visit
    before_action :set_visit_variables
  end

  private

  def track_visit
    return if request.xhr? || request.format.json? # Skip tracking for AJAX/JSON requests
    return if request.path.start_with?('/assets/') # Skip tracking for asset requests
    
    begin
      visit = Visit.find_or_initialize_by(page_path: request.path)
      @last_visited_at = visit.last_visited_at # Store previous value before updating
      @current_visit = Visit.record_visit(request.path)
      @total_visits = Visit.sum(:visit_count)
    rescue => e
      Rails.logger.error "Error tracking visit: #{e.message}"
      @current_visit = nil
      @total_visits = 0
      @last_visited_at = nil
    end
  end

  def set_visit_variables
    return if @current_visit # Skip if already set by track_visit
    
    begin
      visit = Visit.find_by(page_path: request.path)
      @last_visited_at = visit&.last_visited_at
      @current_visit = visit
      @total_visits ||= Visit.sum(:visit_count)
    rescue => e
      Rails.logger.error "Error setting visit variables: #{e.message}"
      @current_visit = nil
      @total_visits = 0
      @last_visited_at = nil
    end
  end
end 