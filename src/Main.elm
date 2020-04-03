module Main exposing (main)

import Array
import Browser

import Html exposing (Html, div, button, input, br, h3)
import Html.Events exposing (onClick, onInput)
import Html.Attributes as At

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

init : Model
init = 
    Model 
        [ Shape 1 Ellipse "500" "300" "50" "50" "blue" "Shape 1"
        , Shape 2 Rectangle "100" "100" "100" "50" "red" "Shape 2"
        ] 
        Ellipse "50" "50" "50" "50" "blue" 1 "Shape 1"

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
                    model.inputColor model.inputName
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
            , inputName = selectedShape.name
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
                                model.inputColor model.inputName
                        else 
                            shape
                        ) model.svgShapes
            in
            
            { model | svgShapes = editedShapes }

        InputName name ->
            { model | inputName = name }



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
        
        selectShapeButtons = 
            List.map (\shape -> selectShapeButton shape) model.svgShapes
        
    in
    
    div [ At.class "app" ] 
        [ div [ At.class "canvas" ] [ svg [width "1000", height "600"]  svgShapes ]
        , h3 [ At.class "title", At.class "propertiesTitle" ] [ text "Properties" ]
        , div [ At.class "editor" ] 
            [ div [ At.class "showSelected" ] [text <| "Selected Shape: " ++ model.inputName]
            , propertyInputs 
                model.inputName model.inputXPos 
                model.inputYPos model.inputWidth 
                model.inputHeight model.inputColor
            , commandButtons
            , div [ At.class "convertedCode" ] [ text convertedCode ]
            ]
        , h3 [ At.class "title", At.class "shapesTitle" ] [ text "Shapes" ]
        , div [ At.class "selectShapeButtons" ] selectShapeButtons
        ]