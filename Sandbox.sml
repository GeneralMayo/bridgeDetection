(* Write anything you want in the structure below. To use it at the REPL, do
 * - CM.make "sandbox.cm"; open Sandbox; *)
structure Sandbox =
struct
  structure STSeq : ST_SEQUENCE = MkSTSequence (structure Seq = ArraySequence)
  structure Seq = STSeq.Seq

  (* your code, from MkBridges.sml *)
  structure Bridges : BRIDGES = MkBridges (structure STSeq = STSeq)

  (* For your convenience... *)
  fun eToS (x, y) =
    String.concat [ "(", Int.toString x, ",", Int.toString y, ")" ]
  val edgesToString = Seq.toString eToS

  (* An example test *)
  fun example () =
    let
      (*
      val test = Seq.% [(0, 1), (1, 2), (1, 3), (0, 4), (4, 5), (4, 6)]*)
      val test = Seq.% [(1,2),(1,7),(2,3),(2,4),(3,7),(3,5),(4,6),(4,5),(7,8)]
      val _ = print (edgesToString test ^ "\n")
      val tree_bridges = Bridges.findBridges (Bridges.makeGraph test)
      
      val _ = print (Seq.toString (fn(u,v)=>("("^(Int.toString u)^","^(Int.toString v)^")")) tree_bridges)
      (*
      val G2 = Seq.collect Int.compare tree

      fun g2ElemPrint g2Elem =
        case g2Elem of
          (v,n) => "<"^(Int.toString v)^"<"^(Seq.toString Int.toString n)^">>\n"

      val _ = print (Seq.toString g2ElemPrint G2)*)

    in
      ()
    end
end