module HelperFunctions exposing (..)

import CustomTypes exposing (..)
import Svg exposing (Svg)
import Svg.Attributes exposing (..)

import Html exposing (text, button, Html)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)

getSelectedShape : List Shape -> Int -> Shape
getSelectedShape listToFilter id =
    let
        filterList = List.head <| List.filter (\shape -> shape.id == id) listToFilter
    in
    case filterList of
        Just shape ->
            shape
        Nothing -> 
            Shape 1 Ellipse "50" "50" "50" "50" "blue" 

convertToCode : ShapeType -> String -> String -> String -> String -> String -> String
convertToCode shapeType xPos yPos width height color = 
    if shapeType == Ellipse then
        String.concat
            [ "<ellipse cx=\'", xPos
            , "\' cy=\'" ++ yPos
            , "\' rx=\'" ++ width
            , "\' ry=\'" ++ height
            , "\' fill=\'" ++ color
            , "\'/>"
            ]
    else 
        String.concat
            [ "<rect x=\'", xPos
            , "\' y=\'" ++ yPos
            , "\' width=\'" ++ width
            , "\' height=\'" ++ height
            , "\' fill=\'" ++ color
            , "\'/>"
            ]

convertToSvg : List Shape -> Int -> List (Svg Msg)
convertToSvg listWithElements selectedShape = 
    List.map (\shape -> 
        if shape.shapeType == Ellipse then
            Svg.ellipse 
                [ cx shape.xPos
                , cy shape.yPos
                , rx shape.width
                , ry shape.height
                , fill shape.color 
                , onClick <| SelectShape shape.id
                , stroke "black",
                if selectedShape == shape.id then
                    strokeWidth "5"
                else
                    strokeWidth "0"
                ] []
        else
            Svg.rect
                [ x shape.xPos
                , y shape.yPos
                , Svg.Attributes.width shape.width
                , Svg.Attributes.height shape.height
                , fill shape.color 
                , onClick <| SelectShape shape.id
                , stroke "black",
                if selectedShape == shape.id then
                    strokeWidth "5"
                else
                    strokeWidth "0"
                ] []
        ) listWithElements

selectShapeButton : Int -> Html Msg
selectShapeButton id =
    button [ onClick <| SelectShape id ] [ text <| "Shape " ++ String.fromInt id ]