# ChristmasTree Step by Step Guidance

## Create New File

* Open FreeCAD in **Sketcher Workbench**
  * Save As: ChristmasTree.FCStd

## Draw the Master Sketch

* Draw the Master Sketch
  * [Master Sketch](./ChristmasTree.Sketch.FCStd)
  * ![master_sketch_images](./Images/Skærmbillede%20fra%202023-12-15%2021-07-07.png)
  * ![master_spreadsheet_images](./Images/)

## Explode Compound

* Select **Part Workbench**
  * Select **Sketch**
    * Select **Part->Compound->Explode compound**

## Pad Explode Compound Sketched

* Select **Part Design Workbench**
  * Select **Combo View-> Sketch.0**
    * Create **Body**
    * Select **Body->BaseFeature**
    * Pad
      * Type: Dimension
      * Length: 5 mm
      * Symmetric to plane: true
  * Select **Combo View->Sketch.1**
    * Create **Body001**
    * Select **Body001->BaseFeature001**
    * Pad
      * Type: Dimension
      * Length: 5 mm
      * Symmetric to plane: true
  * Select **Combo View->Sketch.2**
    * Create **Body002**
    * Select **Body002->BaseFeature002**
    * Pad
      * Type: Dimension
      * Length: 5 mm
      * Symmetric to plane: true
  * Select Combo **View->Sketch.3**
    * Create **Body003**
    * Select **Body003->BaseFeature003**
    * Pad
      * Type: Dimension
      * Length: 5 mm
      * Symmetric to plane: true
  * Select Combo **View->Sketch.4**
    * Create **Body004**
    * Select **Body004->BaseFeature004**
    * Pad
      * Type: Dimension
      * Length: 5 mm
      * Symmetric to plane: true

## Connect Element with Hinge
