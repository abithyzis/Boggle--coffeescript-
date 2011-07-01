(function() {
  var boggle;
  boggle = function() {
    var b, board, num_squares, shake_dice_onto_board, size;
    size = 5;
    num_squares = size * size;
    board = function() {
      var self;
      (function() {
        var i, j, n, table, td, tr;
        table = $("<table border=1>");
        n = 0;
        for (i = 0; i < 5; i++) {
          tr = $("<tr>");
          table.append(tr);
          for (j = 0; j < 5; j++) {
            td = $("<td>x" + i + "," + j + "," + n + "</td>");
            td.attr("id", "pos" + n);
            n += 1;
            tr.append(td);
          }
        }
        return $("#board").append(table);
      })();
      return self = {
        place_die: function(i, value) {
          return $("#pos" + i).html(value);
        }
      };
    };
    b = board();
    shake_dice_onto_board = function() {
      var dice, i, numbers, _i, _results, _results2;
      numbers = (function() {
        _results = [];
        for (var _i = 0; 0 <= num_squares ? _i < num_squares : _i > num_squares; 0 <= num_squares ? _i += 1 : _i -= 1){ _results.push(_i); }
        return _results;
      }).apply(this, arguments);
      dice = _.sortBy(numbers, Math.random);
      _results2 = [];
      for (i = 0; (0 <= num_squares ? i < num_squares : i > num_squares); (0 <= num_squares ? i += 1 : i -= 1)) {
        _results2.push(b.place_die(i, dice[i]));
      }
      return _results2;
    };
    return shake_dice_onto_board();
  };
  jQuery(document).ready(function() {
    return boggle();
  });
}).call(this);
