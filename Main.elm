module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type alias TodoItemModel = 
    {
        id: Int,
        title: String
    }

type alias Model = {
        uid: Int,
        inputValue: String,
        todos: List TodoItemModel
    }

initialModel = { 
        uid = 3,
        inputValue = "",
        todos = [
            { id = 1, title = "React" }, 
            { id = 2, title = "Elm" } 
        ] 
    }

type Msg =
        DeleteTodo Int
        | AddTodo
        | UpdateField String

todoItemView todo =
    li []
    [
        div [] [ 
            text todo.title,
            button [ class "btn", onClick ( DeleteTodo todo.id ) ] [text "X"] 
        ]
    ]

view model = 
    div [ class "app" ]
    [
        input [ 
                value model.inputValue, 
                onInput UpdateField
            ] [],
        button [ onClick AddTodo ] [ text "Add" ],
        ul [ class "results" ] (List.map todoItemView model.todos)
    ]

update: Msg -> Model -> Model
update msg model =
    case msg of
      DeleteTodo id -> 
            { model | todos = List.filter (\m -> m.id /= id ) model.todos }

      UpdateField str -> { model | inputValue = str }

      AddTodo -> { model | todos = model.todos ++ [ { id = model.uid, title = model.inputValue } ] , uid = model.uid + 1, inputValue = "" }

main = Html.beginnerProgram {
            view = view,
            update = update,
            model = initialModel
        }