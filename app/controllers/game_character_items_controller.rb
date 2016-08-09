class GameCharacterItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_owner

  def create
    user = User.find params[:user_id]
    game_character = user.game_character
    item = Item.find params[:item_id]
    if game_character.gold >= item.price
      if GameCharacterItem.give_items_to_character(game_character, item)
        # redirect_to user_game_character_path(user, game_character), notice: "#{item.name} is in your inventory!"
        head :ok
      else
        # redirect_to user_game_character_path(user, game_character), alert: "You cannot have more than 6 items!"
        head :not_acceptable
      end
    else
      # redirect_to user_game_character_path(user, game_character), alert: "Not enough gold!"
      head :not_acceptable
    end
  end

  def destroy

    user = User.find params[:user_id]
    game_character = user.game_character
    game_character_item = GameCharacterItem.find params[:id]
    sell_price = Item.find(game_character_item.item_id).price / 2
    game_character_item.destroy
    game_character.update(gold: game_character.gold + sell_price)
    head :ok
    # redirect_to user_game_character_show_character_path(user, game_character), notice: "Item Sold!"
    #redirect_to root_path
  end
end
