module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


type alias TodoItemModel =
    { id : Int
    , title : String
    , completed : Bool
    }


type alias Model =
    { uid : Int
    , inputValue : String
    , todos : List TodoItemModel
    }


initialModel =
    { uid = 3
    , inputValue = ""
    , todos =
        [ { id = 1, title = "React", completed = True }
        , { id = 2, title = "Elm", completed = False }
        ]
    }


type Msg
    = DeleteTodo Int
    | AddTodo
    | UpdateField String
    | ToggleTodo Int


todoItemView todo =
    li []
        [ div []
            [ input [ type_ "checkbox", checked todo.completed, onClick (ToggleTodo todo.id) ] []
            , text todo.title
            , button [ class "btn", onClick (DeleteTodo todo.id) ] [ text "X" ]
            ]
        ]


view model =
    div [ class "app" ]
        [ input
            [ value model.inputValue
            , onInput UpdateField
            , onEnter AddTodo
            ]
            []
        , button [ onClick AddTodo ] [ text "Add" ]
        , ul [ class "results" ] (List.map todoItemView model.todos)
        ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter keyCode)


update : Msg -> Model -> Model
update msg model =
    let
        addItem m =
            { m
                | todos =
                    m.todos
                        ++ [ { id = m.uid
                             , title = m.inputValue
                             , completed = False
                             }
                           ]
                , uid = m.uid + 1
                , inputValue = ""
            }
    in
        case msg of
            DeleteTodo id ->
                { model | todos = List.filter (\m -> m.id /= id) model.todos }

            UpdateField str ->
                { model | inputValue = str }

            AddTodo ->
                addItem model

            ToggleTodo id ->
                let
                    updateItem t =
                        if t.id == id then
                            { t | completed = not t.completed }
                        else
                            t
                in
                    { model | todos = List.map updateItem model.todos }


main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }
