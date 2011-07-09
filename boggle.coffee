Util =
  build_table_from_2d_cell_array: (array_2d) ->
    table = $("<table border=1>")
    for row in array_2d
      tr = $("<tr>")
      for td in row
        tr.append(td)
      table.append(tr)
    table
  shuffle_array: (array) ->
    _.sortBy(array, Math.random)
  random_char: (s) ->
    i = Math.floor(Math.random() * s.length)
    s.charAt(i)
  
DiceShaker =
  shake: (num_squares, letter_dice) ->
    throw "unexpected number of dice" if num_squares != letter_dice.length
    numbers = [0...num_squares]
    dice = Util.shuffle_array(numbers)
    _.map dice, (die) ->
      letter = Util.random_char letter_dice[die]
      letter = 'QU' if letter == 'Q'
      letter
  
Board = (display, size, letter_dice) ->
  num_squares = size * size
  dice = DiceShaker.shake(num_squares, letter_dice)
  shake_dice_onto_board = ->
    for die, i in dice
      display.place_die(i, die)
  shake_dice_onto_board()
  self =
    get_letter: (i) -> dice[i]
    for_all_squares: (f) ->
      for square in [0...num_squares] by 1
        f(square)
    is_adjacent: (s1, s2) ->
      return false if s1 == s2
      r1 = Math.floor(s1 / size)
      c1 = s1 % size
      r2 = Math.floor(s2 / size)
      c2 = s2 % size
      return (Math.abs(r1-r2) <= 1) && (Math.abs(c1-c2) <= 1)

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
        callback(self.index(this))
      $("td").click handler
    color: (pos, color) ->
      self.square(pos).css("background", color)
    word_entry: ->
      span = $("<span>")
      $("#boggle").append(span)
      field = $("<pre>")
      span.append(field)
      back_button = $("<input type='button'>")
      back_button.attr("value", "BACK")
      span.append(back_button)
      back_button.hide()
      self =
        field:
          set: (text) -> field.html(text)
        back_button:
          hide: -> back_button.hide()
          show: -> back_button.show()
          on_click: (f) -> back_button.click(f)
        
Word_builder = (board) ->
  square_indexes = []
  self =
    add: (i) ->
      square_indexes.push(i)
    backspace: ->
      square_indexes.pop()
    text: ->
      _.map(square_indexes, (i) ->
        board.get_letter(i)
      ).join('')
    already_used: (i) ->
      i in square_indexes
    in_reach: (new_i) ->
      return true if square_indexes.length == 0
      last_square = self.last_square_selected()
      board.is_adjacent(last_square, new_i) 
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

Word_entry = (board, display) ->
  color_all_squares = ->
    board.for_all_squares (i) ->
      display.color(i, word.color(i))

  redraw = ->
    color_all_squares()
    text = word.text()
    field.set(text)
    if text.length > 0
     back_button.show()
    else
      back_button.hide()
  
  on_click_letter = (i) ->
    if !word.legal(i)
      alert "illegal square choice" 
      return
    word.add(i)
    redraw()

  backspace = ->
    word.backspace()
    redraw()

  word = Word_builder(board)
  {field, back_button} = display.word_entry()

  display.on_click_square on_click_letter
  back_button.on_click backspace

LetterDice =
  [
    "AAEEGN",
    "ELRTTY",
    "AOOTTW",
    "ABBJOO",
    "EHRTVW",
    "CIMOTU",
    "DISTTY",
    "EIOSST",
    "DELRVY",
    "ACHOPS",
    "HIMNQU",
    "EEINSU",
    "EEGHNW",
    "AFFKPS",
    "HLNNRZ",
    "DEILRX",
  ]

boggle = ->
  size = 4

  do ->
    display = Display(size)
    board = Board(display, size, LetterDice)
    entry = Word_entry(board, display)

jQuery(document).ready ->
  boggle()