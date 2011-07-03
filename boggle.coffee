boggle = ->
  size = 5
  num_squares = size * size
  board = ->
    table_data = ->
      _.map [0...5], (row) ->
        _.map [0...5], (col) ->
          n = row * size + col
          $("<td>").attr("id", "pos#{n}")
          
    do ->
      table = $("<table border=1>")
      for row in table_data()
        tr = $("<tr>")
        for td in row
          tr.append(td)
        table.append(tr)
      $("#board").append(table)

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
          callback(self.index(this))
        $("td").click handler
      highlight: (pos) ->
        self.square(pos).css("background", "green")
      lowlight: (pos) ->
        self.square(pos).css("background", "white")

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
      
  b = board()
  b.on_click_square (square) ->
    f = (i) ->
      is_adjacent(i, square)
    touch_all_squares(f, b.highlight, b.lowlight)

  shake_dice_onto_board = ->
    numbers = [0...num_squares]
    dice = _.sortBy(numbers, Math.random)
    for i in [0...num_squares] by 1
      b.place_die(i, dice[i])
  shake_dice_onto_board()
  
jQuery(document).ready ->
  boggle()