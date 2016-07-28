class ItemsController < ApplicationController

  def index
    @items = Item.order("price")
  end

  def show
    @item = Item.find params[:id]
    @strength = @item.item_stats.find_by_stat_id(13).value if @item.item_stats.find_by_stat_id(13)
    @constitution = @item.item_stats.find_by_stat_id(14).value if @item.item_stats.find_by_stat_id(14)
  end

end
