module Main exposing (main)

import Array
import Browser

import Html exposing (Html, div, button, input, br)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)

import Svg exposing (Svg, svg, text)
import Svg.Attributes exposing (..)

import Components exposing (..)
import CustomTypes exposing (..)
import HelperFunctions exposing (..)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

type alias Model = 
    { svgShapes : List Shape
    , inputShapeType : ShapeType
    , inputXPos : String
    , inputYPos : String
    , inputWidth : String
    , inputHeight : String
    , inputColor : String
    , selectedShape : Int
    }


init : Model
init = 
    Model 
        [ Shape 1 Ellipse "50" "50" "50" "50" "blue"
        , Shape 2 Rectangle "60" "50" "50" "50" "red"
        ] 
        Ellipse "50" "50" "50" "50" "blue" 1

update : Msg -> Model -> Model
update msg model =
    let
        arrayShapes = Array.fromList model.svgShapes
        nextId = 
            case Array.get (Array.length arrayShapes - 1) arrayShapes of
                Just shape ->
                    shape.id + 1
                Nothing ->
                    1
            
    in
    
    case msg of 
        CreateShape ->
            { model 
            | svgShapes = 
                model.svgShapes ++ 
                    [ Shape 
                    nextId model.inputShapeType 
                    model.inputXPos model.inputYPos 
                    model.inputWidth model.inputHeight
                    model.inputColor
                    ] 
            , selectedShape = nextId
            }

        InputShapeType shapeType ->
            { model | inputShapeType = shapeType}

        InputXPos xPos ->
            { model | inputXPos = xPos}

        InputYPos yPos ->
            { model | inputYPos = yPos }

        InputWidth inputWidth ->
            { model | inputWidth = inputWidth }

        InputHeight inputHeight ->
            { model | inputHeight = inputHeight }

        InputColor color ->
            { model | inputColor = color }

        SelectShape id->
            let
                selectedShape = getSelectedShape model.svgShapes id
            in
            
            { model 
            | selectedShape = id
            , inputShapeType = selectedShape.shapeType
            , inputColor = selectedShape.color
            , inputHeight = selectedShape.height
            , inputWidth = selectedShape.width
            , inputXPos = selectedShape.xPos
            , inputYPos = selectedShape.yPos
            }

        RemoveShape ->
            let
                removedShapes = 
                    List.filter (\shape -> shape.id /= model.selectedShape) model.svgShapes
            in
            { model | svgShapes = removedShapes }

        EditShape ->
            let
                editedShapes =
                     List.map (\shape -> 
                        if shape.id == model.selectedShape then
                            Shape shape.id model.inputShapeType
                                model.inputXPos model.inputYPos 
                                model.inputWidth model.inputHeight
                                model.inputColor
                        else 
                            shape
                        ) model.svgShapes
            in
            
            { model | svgShapes = editedShapes }




view : Model -> Html Msg
view model =
    let
        svgShapes = 
            convertToSvg
                model.svgShapes
                model.selectedShape
        
        convertedCode =
            convertToCode
                model.inputShapeType
                model.inputXPos
                model.inputYPos
                model.inputWidth
                model.inputHeight
                model.inputColor
        
    in
    
    div [] 
        [ svg [width "600", height "400", Html.Attributes.style "border" "solid"] svgShapes 
        , br [] []
        , div [] [text <| "Selected Shape: shape " ++ String.fromInt model.selectedShape]
        , chooseShape Ellipse "Ellipse"
        , chooseShape Rectangle "Rectangle"
        , br [] []
        , propertyInput "x pos: " InputXPos model.inputXPos 
        , propertyInput "y pos: " InputYPos model.inputYPos
        , propertyInput "width: " InputWidth model.inputWidth
        , propertyInput "height: " InputHeight model.inputHeight
        , propertyInput "color: " InputColor model.inputColor
        , applyFunction EditShape "Edit Shape"
        , br [] []
        , applyFunction CreateShape "Create Shape"
        , br [] []
        , applyFunction RemoveShape "Remove Shape"
        , div [ Html.Attributes.class "convertedCode" ] [ text convertedCode ]
        ]