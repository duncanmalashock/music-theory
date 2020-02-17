module MusicTheory.Analyze.ChordClass exposing
    ( TertianFactorsByCategory
    , inScaleClass
    , isInScaleClass
    , scaleClassesFor
    , tertianFactorsByCategory
    )

import MusicTheory.Analyze.TertianFactors as AnalyzeTertianFactors
import MusicTheory.ChordClass as ChordClass
import MusicTheory.Interval as Interval
import MusicTheory.ScaleClass as ScaleClass
import MusicTheory.TertianFactors as TertianFactors


isInScaleClass : ScaleClass.ScaleClass -> ChordClass.ChordClass -> Bool
isInScaleClass scaleClass chordClass =
    List.all
        (\interval ->
            List.member interval
                (ScaleClass.toIntervals scaleClass
                    |> List.map Interval.semitones
                )
        )
        (ChordClass.toIntervals chordClass
            |> List.map Interval.semitones
        )


inScaleClass : ScaleClass.ScaleClass -> List ChordClass.ChordClass
inScaleClass scaleClass =
    ChordClass.all
        |> List.filter (isInScaleClass scaleClass)


scaleClassesFor : ChordClass.ChordClass -> List ScaleClass.ScaleClass
scaleClassesFor chordClass =
    List.filter
        (\scaleClass ->
            isInScaleClass scaleClass chordClass
        )
        ScaleClass.all


type alias TertianFactorsByCategory =
    { root : List TertianFactors.TertianFactor
    , third : List TertianFactors.TertianFactor
    , fifth : List TertianFactors.TertianFactor
    , seventh : List TertianFactors.TertianFactor
    }


tertianFactorsByCategory : ChordClass.ChordClass -> Result ChordClass.ChordClassError TertianFactorsByCategory
tertianFactorsByCategory chordClass =
    ChordClass.toTertianFactors chordClass
        |> Result.map TertianFactors.toList
        |> Result.map
            (\list ->
                { root = List.filter AnalyzeTertianFactors.isRootToneCategory list
                , third = List.filter AnalyzeTertianFactors.isThirdToneCategory list
                , fifth = List.filter AnalyzeTertianFactors.isFifthToneCategory list
                , seventh = List.filter AnalyzeTertianFactors.isSeventhToneCategory list
                }
            )
