match
  (seed:Pkg {seed:true}), (stdlib:Pkg {stdlib:true}),
  p = (seed)-[rs:IMPORTS*]->(stdlib)
where
  none(r IN rs WHERE startNode(r).stdlib)
with
  seed, p,
  [x IN nodes(p) WHERE NOT x.path =~ (seed.path + '.*') | x.path] as nonTreeNodes
return seed.path, max(length(nonTreeNodes)) as hops
order by hops desc
