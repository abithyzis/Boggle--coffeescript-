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
      index: (element) ->
        id = $(element).attr("id")
        id.match(/\d+/)[0]
      place_die: (i, value) ->
        self.square(i).html(value)
      hover_square: (in_callback, out_callback) ->
        in_handler = ->
          in_callback(self.index(this))
        out_handler = ->
          out_callback(self.index(this))
        $("td").hover(in_handler, out_handler)
      highlight: (pos) ->
        self.square(pos).css("background", "green")
      lowlight: (pos) ->
        self.square(pos).css("background", "white")

  b = board()
  b.hover_square(b.highlight, b.lowlight)

  shake_dice_onto_board = ->
    numbers = [0...num_squares]
    dice = _.sortBy(numbers, Math.random)
    for i in [0...num_squares] by 1
      b.place_die(i, dice[i])
  shake_dice_onto_board()
  
jQuery(document).ready ->
  boggle()