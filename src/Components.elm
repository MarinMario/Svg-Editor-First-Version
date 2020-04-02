module Components exposing (..)

import Html exposing (Html, div, input, br, button)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (value)

import CustomTypes exposing (Msg(..), ShapeType)

propertyInput : String -> (String -> Msg) -> String -> Html Msg
propertyInput theText theInput theValue =
    div [] 
        [ Html.text theText
        , input [ onInput theInput, value theValue ] []
        , br [] []
        ]

chooseShape : ShapeType -> String -> Html Msg
chooseShape shapeType textToShow=
    button [ onClick <| InputShapeType shapeType ] [ Html.text textToShow ]

applyFunction : Msg -> String -> Html Msg
applyFunction msg textToShow =
    button [ onClick msg ] [ Html.text textToShow ]