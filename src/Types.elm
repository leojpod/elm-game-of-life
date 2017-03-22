module Types exposing (Cell(..), Board, Model, Msg(..))

-- MODEL


type Cell
    = Empty
    | Dead
    | Alive


type alias Board =
    List (List Cell)


type alias Model =
    { board : Board }



-- MESSAGE


type Msg
    = BoardUpdate Board
    | Tick
    | NoOps
