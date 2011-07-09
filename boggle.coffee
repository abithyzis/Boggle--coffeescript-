Util =
  build_table_from_2d_cell_array: (array_2d) ->
    table = $("<table border=1>")
    for row in array_2d
      tr = $("<tr>")
      for td in row
        tr.append(td)
      table.append(tr)
    table

Display = (size) ->
  do ->
    table_data = ->
      _.map [0...size], (row) ->
        _.map [0...size], (col) ->
          n = row * size + col
          $("<td>").attr("id", "pos#{n}").css("height", "30px").css("width", "30px")

    table = Util.build_table_from_2d_cell_array(table_data())
    $("#boggle").append(table)

  self =
    square: (i) ->
      $("#pos#{i}")
    index: (element) ->
      id = $(element).attr("id")
      parseInt(id.match(/\d+/)[0])
    place_die: (i, value) ->
      self.square(i).html(value)
    on_click_square: (callback) ->
      handler = ->
        i = self.index(this)
        callback(i, $(this))
      $("td").click handler
    color: (pos, color) ->
      self.square(pos).css("background", color)

Word_builder = (is_adjacent) ->
  square_indexes = []
  self =
    add: (i) ->
      square_indexes.push(i)
    already_used: (i) ->
      i in square_indexes
    in_reach: (new_i) ->
      return true if square_indexes.length == 0
      last_square = self.last_square_selected()
      is_adjacent(last_square, new_i) 
    legal: (new_i) ->
      self.in_reach(new_i) && !self.already_used(new_i)
    last_square_selected: () ->
      return undefined if square_indexes.length == 0
      square_indexes[square_indexes.length - 1]
    color: (i) ->
      return "lightgreen" if i == self.last_square_selected()
      return "lightblue" if self.already_used(i)
      return "white" if self.in_reach(i)
      return "red"

boggle = ->
  size = 4
  num_squares = size * size

  word_entry = (display, is_adjacent) ->
    field_builder = ->
      field = $("<pre>")
      $("#boggle").append(field)
      field

    color_all_squares = ->
      for_all_squares (i) ->
        display.color(i, word.color(i))

    word = Word_builder(is_adjacent)
    field = field_builder()
    display.on_click_square (i, square) ->
      if !word.legal(i)
        alert "illegal square choice" 
        return
      word.add(i)
      color_all_squares()
      field.append("_" + square.html())
          
  is_adjacent = (s1, s2) ->
    return false if s1 == s2
    r1 = Math.floor(s1 / size)
    c1 = s1 % size
    r2 = Math.floor(s2 / size)
    c2 = s2 % size
    return (Math.abs(r1-r2) <= 1) && (Math.abs(c1-c2) <= 1)
    
  for_all_squares = (f) ->
    for square in [0...num_squares] by 1
      f(square)

  do ->
    display = Display(size)
    entry = word_entry(display, is_adjacent)

    shake_dice_onto_board = ->
      numbers = [0...num_squares]
      dice = _.sortBy(numbers, Math.random)
      for i in [0...num_squares] by 1
        display.place_die(i, dice[i])
    shake_dice_onto_board()
  
jQuery(document).ready ->
  boggle()