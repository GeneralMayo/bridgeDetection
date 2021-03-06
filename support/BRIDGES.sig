signature BRIDGES =
sig
  structure Seq : SEQUENCE

  type vertex
  type edge = vertex * vertex
  type edges = edge Seq.t

  type ugraph

  (* Takes a sequence of undirected edges as (u,v) pairs and returns the
   * corresponding graph. Each edge will appear only once.
   *)
  val makeGraph : edges -> ugraph

  (* Returns a sequence of bridge edges in the input graph. *)
  val findBridges : ugraph -> edges
end
