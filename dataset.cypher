CREATE CONSTRAINT ON (p:Pkg) ASSERT p.path IS UNIQUE;

USING PERIODIC COMMIT 500

LOAD CSV WITH HEADERS FROM "file:///Users/flazz/p/go/src/github.com/flazz/pkg-deps/var/pkgs.csv" AS csvLine
CREATE (p:Pkg { path: csvLine.path, name: csvLine.name, stdlib: csvLine.stdlib });


LOAD CSV FROM "file:///Users/flazz/p/go/src/github.com/flazz/pkg-deps/var/imports.csv" AS csvLine
MATCH (a:Pkg),(b:Pkg)
WHERE a.path = csvLine[0] AND b.path = csvLine[1]
MERGE (a)-[:IMPORTS]->(b);
