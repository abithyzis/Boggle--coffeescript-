boggle = ->
  size = 5
  num_squares = size * size
  board = ->
    table = $("<table border=1>")
    for i in [0...5]
      tr = $("<tr>")
      table.append(tr)
      for j in [0...5]
        td = $("<td>x#{i},#{j}</td>")
        tr.append(td)
    $("#board").append(table)    
  board()
  
jQuery(document).ready ->
  boggle()