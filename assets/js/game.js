import '../node_modules/@chrisoakman/chessboardjs/dist/chessboard-1.0.0.min.css'
import '../node_modules/@chrisoakman/chessboardjs/dist/chessboard-1.0.0.min.js'

function pieceTheme(piece) {
  return '../images/' + piece + '.png'
}

function handleMove(
  source,
  target,
  piece,
  newPos,
  oldPos,
  orientation,
  onChange
) {
  onChange(source + target)
}

function onDragStart(source, piece, position, orientation) {
  // only pick up pieces for White
  if (piece.search(/^b/) !== -1) return false
}

export const initGame = (pos, onChange) => {
  const config = {
    draggable: true,
    onDragStart: onDragStart,
    onDrop: (source, target, piece, newPos, oldPos, orientation) =>
      handleMove(source, target, piece, newPos, oldPos, orientation, onChange),
    pieceTheme: pieceTheme,
    position: pos,
  }

  if ($('#board').length > 0) {
    window.board = ChessBoard('board', config)
  }

  return window.board
}
