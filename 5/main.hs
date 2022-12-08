main = do
  content <- readFile "input"
  print $ tops $ part1 (lines content) initial
  print $ tops $ part2 (lines content) initial


-- move :: from -> to -> before -> after
move :: Int -> Int -> [[Char]] -> [[Char]]
move from to original = prependToIndex to letter nextState
  where (letter, nextState) = removeFromIndex from original

multiMove :: (Int, Int, Int) -> [[Char]] -> [[Char]]
multiMove (0,_,_) state = state
multiMove (i,from,to) state = multiMove (i-1,from,to) (move from to state)

multiMove' (i,from,to) state = do
  let nextState = multiMove (i,from,to) state
      left = take (to-1) nextState
      right = tail (drop (to-1) nextState)
      middle = (reverse (take i (nextState !! (to-1)))) ++ (drop i (nextState !! (to-1))) in
        left ++ middle : right

prependToIndex :: Int -> Char -> [[Char]] -> [[Char]]
prependToIndex 1 char (x:xs) = (char : x) : xs
prependToIndex i char (x:xs) = x : prependToIndex (i-1) char xs

removeFromIndex :: Int -> [[Char]] -> (Char, [[Char]])
removeFromIndex 1 (x:xs) = (head x, (tail x) : xs)
removeFromIndex i (x:xs) = (fst result, x : (snd result))
  where result = removeFromIndex (i-1) xs

initial :: [[Char]]
initial = [
  ['V','Q','W','M','B','N','Z','C'],
  ['B','C','W','R','Z','H'],
  ['J','R','Q','F'],
  ['T','M','N','F','H','W','S','Z'],
  ['P','Q','N','L','W','F','G'],
  ['W','P','L'],
  ['J','Q','C','G','R','D','B','V'],
  ['W','B','N','Q','Z'],
  ['J','T','G','C','F','L','H']
    ]

parseMove :: String -> (Int, Int, Int)
parseMove move
  | length move == 18 = (read [(move !! 5)], read [(move !! 12)], read [(move !! 17)])
  | otherwise = (read [(move!!5), (move!!6)], read [(move !! 13)], read [move !! 18])

tops :: [String] -> String
tops [] = []
tops (x:xs) = head x : tops xs

part1 :: [String] -> [[Char]] -> [[Char]]
part1 [] before = before
part1 (action:actions) before = part1 actions (multiMove (i,from,to) before)
  where (i,from,to) = parseMove action

part2 :: [String] -> [[Char]] -> [[Char]]
part2 [] before = before
part2 (action:actions) before = part2 actions (multiMove' (i,from,to) before)
  where (i,from,to) = parseMove action
