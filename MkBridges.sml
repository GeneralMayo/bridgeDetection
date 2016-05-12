functor MkBridges(structure STSeq : ST_SEQUENCE)
  :> BRIDGES where type 'a Seq.t = 'a STSeq.Seq.t and type vertex = int =
struct
  structure Seq = STSeq.Seq

  type vertex = int
  type edge = vertex * vertex
  type edges = edge Seq.t

  (* Remove the following line before submittting. *)
  exception NotYetImplemented
  exception TfBeforeTd
  exception NoTimeStamp
  exception NoParrent

  (* Redefine this. *)
  type ugraph = int Seq.t Seq.t

  fun makeGraph (E : edges) : ugraph =
    let
      (*reverse edges and combine reversed edges with normal edges
        so all verticies show up in adjacency table*)
      fun mapFun edge =
        case edge of
          (u,v) => (v,u)
      val reverseEdges = Seq.map mapFun E
      val combinedEdges = Seq.append(E,reverseEdges)
    in
      Seq.map (fn (_,eSeq) => eSeq) (Seq.collect Int.compare combinedEdges)
    end

  fun findBridges (G : ugraph) : edges =
    let
      (*getTimeStamp of vertex v*)
      fun getTimeStamp x v =
        case STSeq.nth x v of
          NONE => raise NoTimeStamp
          | SOME ts => ts 

      (*get the value of the parrent verticy if it exists*)
      fun getParrent p =
        case p of
          NONE => raise NoParrent
          | SOME pVal => pVal

      fun parrentToString p =
        case p of
          NONE => "NONE"
          | SOME pVal => "SOME "^Int.toString pVal

      fun dfs ((x, t, cStart, cEnd, bridges, p1, p2), v) =
          (*if v has been visited*)
          if not((STSeq.nth x v)=NONE) then
            (*test if parrent is acting as a neighbor*)
            if not(p2=NONE) andalso not((getParrent p2)=v) then
              (let
                (*test if v is start of an outer cycle
                  or if its "contained" in a cycle already
                  found*)
                val cStartFound = getTimeStamp x v
                val cStart' = (if  cStartFound< cStart
                  then cStartFound
                  else cStart)
                
                val p1Val = (case p1 of
                  NONE => raise NoTimeStamp
                  |SOME p1Val' => p1Val')

                (*the end of the cycle will always be
                  time stamp of last verticy visited which wasn't
                  a "revisit"*)
                val cEnd' = getTimeStamp x (getParrent p1)
              in
                (x,t,cStart',cEnd',bridges,p1,p2)
              end)
            (*if node found was parrent we disreguard it*)
            else
              (x,t,cStart,cEnd,bridges,p1,p2)
          else
            let              
              (*increment time discovered*)
              val td = t+1
              (*update seen verticies*)
              val x' = STSeq.update (x,(v,SOME td))
              (*get neighbores*)
              val n = Seq.nth G v



              (*iterate over neighbors*)
              val (x'',t',cStart',cEnd',bridges',_,_) = 
                Seq.iterate dfs (x',td,cStart,cEnd,bridges,SOME v,p1) n
              
              (*if current verticy not a part of any cycle found*)
              val bridges'' = (if (td > cEnd')
              then (case p1 of
                NONE => bridges'
                | SOME u => (u,v)::bridges')
              else bridges')

              (*if we recursed backwards to start of the cycle*)
              val (cStart'',cEnd'',bridges''') = 
                (if ((getTimeStamp x'' v) = cStart')
                (*"reset" startC/endC and re-evaluate bridges*)
                then 
                  (let
                    val bNew = (if(td>cEnd)
                      then (case p1 of
                        NONE => bridges''
                        | SOME u => (u,v)::bridges'')
                      else bridges'')
                  in
                    (cStart,cEnd,bNew)
                  end)
                else (cStart',cEnd',bridges''))
            in
              (x'',t',cStart'',cEnd'',bridges''',p1,p2)
            end
      
      (*create initial states*)
      val b0 = []
      val x0 = STSeq.fromSeq (Seq.tabulate (fn i => NONE) (Seq.length G))
      (*number of verticies*)
      val numV = (Seq.length G)
      (*list of verticies*)
      val verticies = Seq.tabulate (fn i => i) numV
      (*iterate through verticies to ensure bridges from all
        unconnected graphs are found*)
      val (xF,tdF,cStartF,cEndF,bridgesF,_,_)
       = Seq.iterate dfs (x0,~1,numV,0,b0,NONE,NONE) verticies 
    in
      Seq.% bridgesF
    end

end
