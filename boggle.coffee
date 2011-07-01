boggle = ->
  size = 5
  num_squares = size * size
  board = ->
    table = $("<table border=1>")
    n = 0
    for i in [0...5]
      tr = $("<tr>")
      table.append(tr)
      for j in [0...5]
        td = $("<td>x#{i},#{j},#{n}</td>")
        td.attr("id", "pos#{n}")
        n += 1
        tr.append(td)
    $("#board").append(table)    
  board()
  shake_dice_onto_board = ->
    numbers = [0...num_squares]
    dice = _.sortBy(numbers, Math.random)
    for i in [0...num_squares]
      $("#pos#{i}").html(dice[i])
  shake_dice_onto_board()
  
jQuery(document).ready ->
  boggle()