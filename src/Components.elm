module Components exposing (..)

import Html exposing (Html, div, input, br, button, text)
import Html.Events exposing (onInput, onClick, onMouseDown)
import Html.Attributes as At

import Svg exposing (Svg)
import Svg.Attributes as Sat

import CustomTypes exposing (Msg(..), ShapeType(..), Shape, Model)

import Html.Events.Extra.Mouse as Mouse

propertyInput : String -> (String -> Msg) -> String -> Html Msg
propertyInput theText theInput theValue =
    div [] 
        [ Html.text theText
        , input [ onInput theInput, At.value theValue ] []
        , br [] []
        ]

chooseShape : ShapeType -> String -> Html Msg
chooseShape shapeType textToShow=
    button [ onClick <| InputShapeType shapeType ] [ Html.text textToShow ]

applyFunction : Msg -> String -> Html Msg
applyFunction msg textToShow =
    button [ onClick msg ] [ Html.text textToShow ]

selectShapeButton : Shape -> Html Msg
selectShapeButton shape =
    button [ onClick <| SelectShape shape.id, At.class "selectShapeButton" ] 
        [ text shape.name ]

propertyInputs : Model -> Html Msg
propertyInputs model =
    div [ At.class "propertyInputs" ] 
        [ text "type: "
        , chooseShape Line "Line"
        , chooseShape Ellipse "Ellipse"
        , chooseShape Rectangle "Rectangle"
        , propertyInput "name: " InputName model.inputName
        , propertyInput "x pos: " InputXPos model.inputXPos
        , propertyInput "y pos: " InputYPos model.inputYPos
        , propertyInput "width: " InputWidth model.inputWidth
        , propertyInput "height: " InputHeight model.inputHeight
        , propertyInput "fill color: " InputColor model.inputColor
        , propertyInput "stroke width: " InputStrokeWidth model.inputStrokeWidth
        , propertyInput "stroke color: " InputStrokeColor model.inputStrokeColor
        ]
        

commandButtons : Html Msg
commandButtons =
    div [ At.class "commandButtons" ] 
        [ applyFunction EditShape "Save"
        , br [] []
        , applyFunction CreateShape "New"
        , br [] []
        , applyFunction RemoveShape "Remove"
        ]


svgEllipse : Shape -> Model -> Svg Msg
svgEllipse shape model =
    Svg.ellipse
        [ Sat.cx shape.xPos
        , Sat.cy shape.yPos
        , Sat.rx shape.width
        , Sat.ry shape.height
        , Sat.fill shape.color 
        , Sat.stroke shape.strokeColor
        , Sat.strokeWidth shape.strokeWidth
        , mouseDownEvent shape model
        ] []

svgRect : Shape -> Model -> Svg Msg
svgRect shape model =
    Svg.rect
        [ Sat.x shape.xPos
        , Sat.y shape.yPos
        , Sat.width shape.width
        , Sat.height shape.height
        , Sat.fill shape.color
        , Sat.stroke shape.strokeColor
        , Sat.strokeWidth shape.strokeWidth
        , mouseDownEvent shape model
        ] []

svgLine : Shape -> Model -> Svg Msg
svgLine shape model =
    Svg.line
        [ Sat.x1 shape.xPos
        , Sat.y1 shape.yPos
        , Sat.x2 shape.width
        , Sat.y2 shape.height
        , Sat.stroke shape.strokeColor
        , Sat.strokeWidth shape.strokeWidth
        , mouseDownEvent shape model
        ] []

mouseDownEvent shape model=
    onMouseDown <| 
        if model.selectedShape == shape.id then
            ShouldDragShape True
        else
            SelectShape shape.id