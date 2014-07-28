module Guesstimate

  def take_turn *args
    @next_move ||= (rand(2) % 2 == 0) ? search_vertical : search_horizontal
    super
  end

private

  def fit_vertical
    columns = rotated_state.each.with_index.inject({}) do |hash, (column, i)|
      fit = column.each_cons(largest_ship).map.with_index do |slice, j|
        j if slice.all? { |pt| pt == :unknown }
      end.compact

      hash[i] = fit if fit.any?
      hash
    end
    columns.any? ? columns : nil
  end

  def fit_horizontal
    rows = @game_state.each.with_index.inject({}) do |hash, (row, i)|
      fit = row.each_cons(largest_ship).map.with_index do |slice, j|
        j if slice.all? { |pt| pt == :unknown }
      end.compact
      hash[i] = fit if fit.any?
      hash
    end

    rows.any? ? rows : nil
  end

  def search_vertical
    if columns = fit_vertical
      columns = columns.to_a
      begin
        x, group = columns.sample # a random column and slice
        y = group.sample + (largest_ship / 2)
        move = Point.new x, y
      end until valid_move? move
      move
    end
  end

  def search_horizontal
    if rows = fit_horizontal
      rows = rows.to_a
      begin
        y, group = rows.sample # a random row and slice
        x = group.sample + (largest_ship / 2)
        move = Point.new x, y
      end until valid_move? move
      move
    end
  end

end
