module HelperFunctions exposing (..)

import CustomTypes exposing (..)
import Svg exposing (Svg)
import Svg.Attributes as Sat

import Html exposing (text, button, Html)
import Html.Events exposing (onClick)
import Html.Attributes as At

import Components exposing (svgEllipse, svgRect, svgLine)

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

convertToCode : Model -> String
convertToCode model = 
    if model.inputShapeType == Ellipse then
        String.concat
            [ "<ellipse cx=\'", model.inputXPos
            , "\' cy=\'" ++ model.inputYPos
            , "\' rx=\'" ++ model.inputWidth
            , "\' ry=\'" ++ model.inputHeight
            , "\' fill=\'" ++ model.inputColor
            , "\'/>"
            ]
    else
        String.concat
            [ "<rect x=\'", model.inputXPos
            , "\' y=\'" ++ model.inputYPos
            , "\' width=\'" ++ model.inputWidth
            , "\' height=\'" ++ model.inputHeight
            , "\' fill=\'" ++ model.inputColor
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
        else if shape.shapeType == Rectangle then
            Svg.g []
                [ svgRect 
                    shape.xPos shape.yPos shape.width 
                    shape.height shape.color shape.id
                ]
        else
            Svg.g []
                [ svgLine
                    shape.xPos shape.yPos shape.width 
                    shape.height shape.color shape.id
                ]
        ) listWithElements

