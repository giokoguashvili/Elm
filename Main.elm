module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { query : String
    , results : List SearchResult
    }


type alias SearchResult =
    { id : Int
    , name : String
    , stars : Int
    }


type alias Msg =
    { operation : String
    , data : Int
    }



initialModel = { 
        todos = [
            { id = 1, title = "React" }, 
            { id = 2, title = "Elm" } 
        ] 
    }

todoItemView todo =
    li []
    [
        div [] [ 
            text todo.title,
            button [ class "btn", onClick { operation = "DELETE_TODO", data = todo.id }] [text "X"] 
        ]
    ]

view model = 
    div [ class "app" ]
    [
        ul [ class "results" ] (List.map todoItemView model.todos)
    ]

update msg model =
    if msg.operation == "DELETE_TODO" then
        { model 
            | todos = List.filter (\m -> m.id /= msg.data ) model.todos 
        }
    else
        model

main = Html.beginnerProgram {
        view = view,
        update = update,
        model = initialModel
    }