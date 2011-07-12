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
  
class DiceShaker
  shake: (num_squares, letter_dice) ->
    throw "unexpected number of dice" if num_squares != letter_dice.length
    numbers = [0...num_squares]
    dice = Util.shuffle_array(numbers)
    _.map dice, (die) ->
      letter = Util.random_char letter_dice[die]
      letter = 'QU' if letter == 'Q'
      letter
  
class Board 
  constructor: (@display, @size, letter_dice) ->
    @num_squares = @size * @size
    @dice = new DiceShaker().shake(@num_squares, letter_dice)
    for die, i in @dice
      display.place_die(i, die)
  get_letter: (i) -> @dice[i]
  for_all_squares: (f) ->
    for square in [0...@num_squares] by 1
      f(square)
  is_adjacent: (s1, s2) ->
    return false if s1 == s2
    r1 = Math.floor(s1 / @size)
    c1 = s1 % @size
    r2 = Math.floor(s2 / @size)
    c2 = s2 % @size
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

  word_entry_span = $("<span>")
  $("#boggle").append(word_entry_span)
  scratchpad  = $("<pre>")
  $("#boggle").append("<h2>Answers</h2>")
  $("#boggle").append(scratchpad)

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
      word_entry_span.html('')
      field = $("<pre>")
      word_entry_span.append(field)
      append_hidden_button = (label) ->
        button = $("<input type='button'>")
        button.attr("value", label)
        word_entry_span.append(button)
        button.hide()
        button
      back_button = append_hidden_button("BACK")
      save_button = append_hidden_button("SAVE")
      self =
        field:
          set: (text) -> field.html(text)
        back_button:
          hide: -> back_button.hide()
          show: -> back_button.show()
          on_click: (f) -> back_button.click(f)
        save_button:
          hide: -> save_button.hide()
          show: -> save_button.show()
          on_click: (f) -> save_button.click(f)
    scratchpad:
      add_word: (s) ->
        console.log("added #{s}")
        scratchpad.append(s + "\n") 
        
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
    validate_new_letter: (new_i) ->
      throw "already used" if self.already_used(new_i)
      throw "out of reach" if !self.in_reach(new_i)
    last_square_selected: () ->
      return undefined if square_indexes.length == 0
      square_indexes[square_indexes.length - 1]
    redraw_board: (display) ->
      color = (i) ->
        return "lightgreen" if i == self.last_square_selected()
        return "lightblue" if self.already_used(i)
        return "white" if self.in_reach(i)
        return "#DDD"
      board.for_all_squares (i) ->
        display.color(i, color(i))
        
Word_entry = (board, display) ->
  word = Word_builder(board)
    
  redraw = ->
    word.redraw_board(display)
    text = word.text()
    field.set(text)
    if text.length > 0
     back_button.show()
     save_button.show()
    else
      back_button.hide()
      save_button.hide()
  
  on_click_letter = (i) ->
    try
      word.validate_new_letter(i)
    catch error
      alert error
      return
    word.add(i)
    redraw()

  backspace = ->
    word.backspace()
    redraw()

  save = ->
    display.scratchpad.add_word(word.text())
    word = Word_builder(board)
    redraw()

  {field, back_button, save_button} = display.word_entry()
  word.redraw_board(display)

  display.on_click_square on_click_letter
  back_button.on_click backspace
  save_button.on_click save

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
    board = new Board(display, size, LetterDice)
    Word_entry(board, display)

jQuery(document).ready ->
  boggle()