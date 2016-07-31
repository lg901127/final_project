class ItemsController < ApplicationController

  def index
    @items = Item.order("price")
    items_info = items_info(@items)
    respond_to do |format|
      format.html
      format.json { render json: items_info }
    end
  end

  def show
    @item = Item.find params[:id]
    @strength = @item.item_stats.find_by_stat_id(13).value if @item.item_stats.find_by_stat_id(13)
    @constitution = @item.item_stats.find_by_stat_id(14).value if @item.item_stats.find_by_stat_id(14)
  end

  private

  def items_info(items)
    items_info = []
    items.each do |item|
      item_info = {
        name: item.name,
        description: item.description,
        price: item.price
      }
      item.item_stats.each do |stat|
        name = Stat.find(stat.stat_id).name
        item_info[name] = stat.value
      end
      items_info << item_info
    end
    items_info
  end

end
