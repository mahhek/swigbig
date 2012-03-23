class Bars::CreditCardsController < ApplicationController
  layout 'bars'

  before_filter :authenticate_bar!

  def show
    @credit_card = current_bar.credit_card
  end

  def edit
    @credit_card = current_bar.credit_card
    @months, @years = [], []
    1.upto(12) { |i| @months << i }
    5.times { |i| @years << Time.now.year + i }

  end

  def update
    @credit_card = current_bar.credit_card

    if @credit_card.nil?
      current_bar.create_credit_card(params[:credit_card])
      if current_bar.create_credit_card(params[:credit_card])
        redirect_to bars_credit_cards_url, notice: 'Your credit card was successfully updated.'
      else
        render action: "edit"
      end
    else
      if @credit_card.update_attributes(params[:credit_card])
        redirect_to bars_credit_cards_url, notice: 'Your credit card was successfully updated.'
      else
        render action: "edit"
      end
    end
  end

end
