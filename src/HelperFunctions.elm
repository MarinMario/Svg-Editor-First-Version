module HelperFunctions exposing (..)

import CustomTypes exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as Sat

import Html exposing (text, button, Html)
import Html.Events exposing (onClick)
import Html.Attributes as At

import Components exposing (svgEllipse, svgRect)

getSelectedShape : List Shape -> Int -> Shape
getSelectedShape listToFilter id =
    let
        filterList = List.head <| List.filter (\shape -> shape.id == id) listToFilter
    in
    case filterList of
        Just shape ->
            shape
        Nothing -> 
            Shape 1 Ellipse "50" "50" "50" "50" "blue" "Shape 1"

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
            Svg.g []
                [ svgEllipse
                    shape.xPos shape.yPos shape.width 
                    shape.height shape.color shape.id
                ]
        else
            Svg.g []
                [ svgRect 
                    shape.xPos shape.yPos shape.width 
                    shape.height shape.color shape.id
                ]
        ) listWithElements

