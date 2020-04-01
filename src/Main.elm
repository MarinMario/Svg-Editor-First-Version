module Main exposing (main)

import Browser

import Array

import Html exposing (Html, div, button, input, br)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (value)

import Svg exposing (Svg, svg, circle, text)
-- import Svg.Events exposing ()
import Svg.Attributes exposing (..)

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

type alias Shape =
    { id : Int
    , shapeType : ShapeType
    , xPos : String
    , yPos : String
    , width : String
    , height : String
    , color : String
    }

type ShapeType = Ellipse | Rectangle

init : Model
init = 
    Model 
        [ Shape 1 Ellipse "50" "50" "50" "50" "blue"
        , Shape 2 Rectangle "60" "50" "50" "50" "red"
        ] 
        Ellipse "50" "50" "50" "50" "blue" 1

type Msg
    = CreateShape
    | InputShapeType ShapeType
    | InputXPos String
    | InputYPos String
    | InputWidth String
    | InputHeight String
    | InputColor String
    | SelectShape Int
    | RemoveShape
    | EditShape

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
                filterId = List.head <| List.filter (\shape -> shape.id == id) model.svgShapes
                selectedShape = 
                    case filterId of
                    Just shape ->
                        shape
                    Nothing -> 
                        Shape 1 Ellipse "50" "50" "50" "50" "blue" 
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
            List.map (\shape -> 
                if shape.shapeType == Ellipse then
                    Svg.ellipse 
                        [ cx shape.xPos
                        , cy shape.yPos
                        , rx shape.width
                        , ry shape.height
                        , fill shape.color 
                        , onClick <| SelectShape shape.id
                        ] []
                else
                    Svg.rect 
                        [ x shape.xPos
                        , y shape.yPos
                        , width shape.width
                        , height shape.height
                        , fill shape.color
                        , onClick <| SelectShape shape.id
                        ] []
                ) model.svgShapes
    in
    
    div [] 
        [ svg [width "600", height "400", Html.Attributes.style "border" "solid"] svgShapes 
        , br [] []
        , text <| "Selected Shape: shape " ++ String.fromInt model.selectedShape
        , br [] []
        , button [ onClick <| InputShapeType Ellipse ] [ text "Ellipse"]
        , button [ onClick <| InputShapeType Rectangle ] [ text "Rectangle" ]
        , br [] []
        , propertyInput "x pos: " InputXPos model.inputXPos
        , propertyInput "y pos: " InputYPos model.inputYPos
        , propertyInput "width: " InputWidth model.inputWidth
        , propertyInput "height: " InputHeight model.inputHeight
        , propertyInput "color: " InputColor model.inputColor
        , button [ onClick EditShape ] [ Html.text "Edit Shape" ]
        , br [] []
        , button [ onClick CreateShape ] [ Html.text "Create Shape" ]
        , br [] []
        , button [ onClick RemoveShape ] [ Html.text "Remove Shape" ]
        ]

propertyInput : String -> (String -> Msg) -> String -> Html Msg
propertyInput theText theInput theValue =
    div [] 
        [ Html.text theText
        , input [ onInput theInput, value theValue ] []
        , br [] []
        ]
    