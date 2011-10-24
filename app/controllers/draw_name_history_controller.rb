class DrawNameHistoryController < ApplicationController
  before_filter :authenticate
  before_filter :admin_user
  
  def create
    drawn_names = DrawnName.all
    if drawn_names.count == 0
      flash[:error] = "No names drawn yet."
      redirect_to draw_names_path
      return
    end
    
    # remove any existing entries for the current year
    histories = DrawnNameHistory.find_all_by_year(drawn_names[0].updated_at.year)
    histories.each do |history|
      history.delete
    end

    # copy current drawn names to history
    success = true
    drawn_names.each do |drawn|
      history = DrawnNameHistory.new
      history.giver = drawn.giver
      history.receiver = drawn.receiver
      history.year = drawn.updated_at.year
      if !history.save
        success = false
        break
      end
    end
  
    flash[:success] = "History stored" if success
    redirect_to draw_names_path
  end
end
