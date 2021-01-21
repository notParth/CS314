open Proj2_types;;
let contract this =
	match this with (x, y) -> x;;
let buildParseTree (input : string list) : tree = 
let rec buildS thisList =
                match thisList with (h::t) ->
                        match h with "TRUE" -> (TreeNode("S", [TreeNode("TRUE", [])]), t)
                                |"FALSE" -> (TreeNode("S", [TreeNode("FALSE", [])]), t)
                                |"(" -> let (node1, rem1) = buildT t in let (node2, rem2) = buildS rem1 in (TreeNode("S", TreeNode("(", []) :: node1::node2::[]), rem2)
                                |")" -> (TreeNode(")", []), t)
                                |_-> (TreeNode("S", [TreeNode(h, [])]), t)
        and buildT thatList =
                match thatList with (h::t) ->
                        match h with "not"-> let (node1, rem1) = buildS t in (TreeNode("T", TreeNode("not", []) :: node1 :: []), rem1)
                                | "and" -> let (node1, rem1) = buildS t in let (node2, rem2) = buildS rem1 in (TreeNode("T", TreeNode("and", []) :: node1 :: node2 :: []), rem2)
				| "or" -> let (node1, rem1) = buildS t in let (node2, rem2) = buildS rem1 in (TreeNode("T", TreeNode("or", []) :: node1 :: node2 :: []), rem2)   
     in contract (buildS input);;

let buildAbstractSyntaxTree (input : tree) : tree = 
	let rec helper thisTree = 
		match thisTree with TreeNode(x, y)->
			match x with "S"->(match y with (h::t1::t2::_)->helper t1
							|(h::_) -> match h with TreeNode(a, b) -> TreeNode(a, []))
				|"T"->(match y with (h::t1::t2::_)->(match h with
									TreeNode("or", [])->TreeNode("or", [helper t1; helper t2])
									|TreeNode("and", [])->TreeNode("and", [helper t1; helper t2]))
						|(h::t::_)->TreeNode("not", [helper t]))
	in helper input;;

let is_alpha s = match s with
"a" -> true | "b" -> true | "c" -> true | "d" -> true | "e" -> true |"f" -> true |"g" -> true 
|"h" -> true |"i" -> true |"j" -> true |"k" -> true |"l" -> true |"m" ->true |"n" -> true 
|"o" -> true |"p" -> true |"q" -> true |"r" -> true |"s" -> true |"t" -> true 
| "u" -> true |"v" -> true |"w" -> true |"x" -> true | "y" -> true | "z"-> true | _ -> false;;

let rec checkIfExists x l = match l with (h::t) -> (if h = x then true else checkIfExists x t) 
			| (h) -> false ;;

let scanVariable (input : string list) : string list = List.fold_left (fun a h -> if is_alpha (h) then (if checkIfExists h a then  a else h :: a) else a) [] input;;

let generateInitialAssignList (varList : string list) : (string * bool) list = List.map (fun x -> match x with _ ->(x, false)) varList;;

let adder (l, c) (x, y) =
        match (x, y) with (_, false) ->
	                	(match (l, c) with (_, false) -> ((x, false) :: l, false)
			        | (_, true) -> ((x, true) :: l, false))
			| (_, true) ->
				(match (l  , c) with (_, false) -> ((x, true) :: l, false)
				| (_, true) -> ((x, false)   :: l, true));;

let generateNextAssignList (assignList : (string * bool) list) : (string * bool) list * bool = List.fold_left adder ([], true) (List.rev(assignList));;

let lookupVar (assignList : (string * bool) list) (str : string) : bool = 
	let rec check list s =
        	match list with (h::t)->
	                match h with (x, y) ->
	                        if(x = s) then y else check (t) s
	in check assignList str;;

let rec evaluateTree (t : tree) (assignList : (string * bool) list) : bool = match t with TreeNode (x, y) ->
	(match x with "not" -> (match (evaluateTree (List.hd(y)) (assignList)) with  true -> false 
										|false -> true)
	|"and"->(match (evaluateTree (List.hd(y)) (assignList)) with true -> (match (evaluateTree (List.hd(List.tl(y))) (assignList)) with true -> true
																   |false -> false)
								 |false -> false)
	|"or"->(match (evaluateTree (List.hd(y)) (assignList)) with true -> true
								|false -> (match (evaluateTree (List.hd(List.tl(y))) (assignList)) with true -> true
																    |false -> false))
	|"TRUE"->true
	|"FALSE"->false
	|_->(lookupVar (assignList) (x)))
	;;

let satisfiable (input : string list) : (string * bool) list list =
	let rec iterate (thisTree : tree) (thisList : ((string * bool)list * bool)) (thatList : (string * bool) list list) : (string * bool) list list =
		match (thisList) with (x, y) ->
			match y with false -> (match (evaluateTree (thisTree) (x)) with true -> (iterate(thisTree) (generateNextAssignList(x)) (x::thatList))
											|false -> (iterate(thisTree) (generateNextAssignList(x)) (thatList)))
				|true -> thatList
	in iterate (buildAbstractSyntaxTree(buildParseTree(input))) (generateInitialAssignList(scanVariable(input)), false) ([]);;
