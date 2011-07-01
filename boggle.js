(function() {
  var boggle;
  boggle = function() {
    var board, num_squares, size;
    size = 5;
    num_squares = size * size;
    board = function() {
      var i, j, table, td, tr;
      table = $("<table border=1>");
      for (i = 0; i < 5; i++) {
        tr = $("<tr>");
        table.append(tr);
        for (j = 0; j < 5; j++) {
          td = $("<td>x" + i + "," + j + "</td>");
          tr.append(td);
        }
      }
      return $("#board").append(table);
    };
    return board();
  };
  jQuery(document).ready(function() {
    return boggle();
  });
}).call(this);
