module Board.Types exposing (Cell(..), Board, BoardMsg(..))

-- Model


type Cell
    = Empty
    | Dead
    | Alive


type alias Board =
    List (List Cell)



-- Msg


type BoardMsg
    = Update Board
    | Tick
