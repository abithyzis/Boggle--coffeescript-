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
  table_data = ->
    _.map [0...size], (row) ->
      _.map [0...size], (col) ->
        n = row * size + col
        $("<td>").attr("id", "pos#{n}").css("height", "30px").css("width", "30px")

  do ->
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
    highlight: (pos) ->
      self.square(pos).css("background", "white")
    lowlight: (pos) ->
      self.square(pos).css("background", "red")


boggle = ->
  size = 4
  num_squares = size * size

  word_entry = (display) ->
    word_builder = ->
      square_indexes = []
      self =
        add: (i) ->
          square_indexes.push(i)
        already_used: (i) ->
          i in square_indexes
        in_reach: (new_i) ->
          return true if square_indexes.length == 0
          i = square_indexes[square_indexes.length - 1]
          is_adjacent(i, new_i) 
        legal: (new_i) ->
          self.in_reach(new_i) && !self.already_used(new_i)
          
    field_builder = ->
      field = $("<pre>")
      $("#boggle").append(field)
      field

    word = word_builder()
    field = field_builder()
    display.on_click_square (i, square) ->
      if !word.legal(i)
        alert "illegal square choice" 
        return
      word.add(i)
      touch_all_squares(word.legal, display.highlight, display.lowlight)
      field.append("_" + square.html())
          
  is_adjacent = (s1, s2) ->
    return false if s1 == s2
    r1 = Math.floor(s1 / size)
    c1 = s1 % size
    r2 = Math.floor(s2 / size)
    c2 = s2 % size
    return (Math.abs(r1-r2) <= 1) && (Math.abs(c1-c2) <= 1)
    
  touch_all_squares = (f, on_handler, off_handler) ->
    for square in [0...num_squares] by 1
      if f(square)
        on_handler(square)
      else
        off_handler(square)

  do ->
    display = Display(size)
    entry = word_entry(display)

    shake_dice_onto_board = ->
      numbers = [0...num_squares]
      dice = _.sortBy(numbers, Math.random)
      for i in [0...num_squares] by 1
        display.place_die(i, dice[i])
    shake_dice_onto_board()
  
jQuery(document).ready ->
  boggle()