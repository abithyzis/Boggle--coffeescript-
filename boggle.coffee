boggle = ->
  size = 5
  num_squares = size * size
  board = ->
    do ->
      table = $("<table border=1>")
      n = 0
      for i in [0...5] by 1
        tr = $("<tr>")
        table.append(tr)
        for j in [0...5] by 1
          td = $("<td>x#{i},#{j},#{n}</td>")
          td.attr("id", "pos#{n}")
          n += 1
          tr.append(td)
      $("#board").append(table)
    self =
      square: (i) ->
        $("#pos#{i}")
      place_die: (i, value) ->
        self.square(i).html(value)
      hover_square: (f) ->
        $("td").hover ->
          id = $(this).attr("id")
          index = id.match(/\d+/)[0]
          f(index)
      highlight: (pos) ->
        self.square(pos).css("background", "green")
        
  b = board()
  b.hover_square (index) ->
    b.highlight(index)

  shake_dice_onto_board = ->
    numbers = [0...num_squares]
    dice = _.sortBy(numbers, Math.random)
    for i in [0...num_squares] by 1
      b.place_die(i, dice[i])
  shake_dice_onto_board()
  
jQuery(document).ready ->
  boggle()