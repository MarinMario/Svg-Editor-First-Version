module Components exposing (..)

import Html exposing (Html, div, input, br, button, text)
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

selectShapeButton : Int -> String -> Html Msg
selectShapeButton id name =
    button [ onClick <| SelectShape id, Html.Attributes.class "selectShapeButton" ] 
        [ text name ]