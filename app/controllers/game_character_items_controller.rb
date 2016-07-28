class GameCharacterItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_owner
  def create
    user = User.find params[:user_id]
    game_character = user.game_character
    item = Item.find params[:item_id]
    if game_character.gold >= item.price
      if GameCharacterItem.give_items_to_character(game_character, item)
        redirect_to user_game_character_path(user, game_character), notice: "#{item.name} is in your inventory!"
      else
        redirect_to user_item_path(user, item), alert: "You cannot have more than 6 items!"
      end
    else
      redirect_to user_items_path(user), alert: "Not enough gold!"
    end
  end

  def destroy
    user = User.find params[:user_id]
    game_character = user.game_character
    game_character_item = GameCharacterItem.find params[:id]
    sell_price = Item.find(game_character_item.item_id).price / 2
    game_character_item.destroy
    game_character.update(gold: game_character.gold + sell_price)
    redirect_to user_game_character_path(user, game_character), notice: "Item Sold!"
  end
end
