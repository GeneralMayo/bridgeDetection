structure Tests =
struct

  (* To test your implementation of findBridges, you'll need to pair 
   * the input graphs with the corresponding desired output.
   *)
  val loner = [(0, 1)]
  val lonerBridges = [(0, 1)]

  val forest = [(0, 1), (2, 3)]
  val forestBridges = [(0, 1), (2, 3)]

  val triangle = [(0, 1), (1, 2), (2, 0)]
  val triangleBridges = []

  val twoTri = [(0,1),(1,2),(1,3),(2,3),(3,4),(4,5),(5,6),(4,6),(6,7)]
  val twoTriB = [(0,1),(3,4),(6,7)]

  val line = [(0,1),(1,2),(2,3),(3,4)]
  val lineB = [(0,1),(1,2),(2,3),(3,4)]

  val doubleC = [(0,1),(0,6),(1,2),(1,3),(2,6),(2,4),(3,5),(3,4),(6,7)]
  val doubleCB = [(3,5),(6,7)]

  (* Each search test is `(w, input, output, str)`, where `w` is a weight (for
   * scoreing), `input` is an edge list representation of the graph, 
   * `output` is the desired list of bridges, and str is the name (string) 
   * of the graph.
   *)
  val tests : (int * ((int * int) list) * ((int * int) list) * string) list =
    [
     (1, loner, lonerBridges, "Loner"),
     (1, forest, forestBridges, "Forest"),
     (1, triangle, triangleBridges, "Triangle"),
     (1, twoTri,twoTriB,"Two Tri"),
     (1, line,lineB,"lineB"),
     (1, doubleC,doubleCB,"DoubleC")
    ]
end
